#####
#"Test effects with distance-based F-test using moment matching"#
#####

# Read input ----
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (index of the array)", call.=FALSE)
} else if (length(args) ==1) {
  # default output file
  args[2] = "./results"
}  

# Pre-set ----
# Set seed for reproducibility
set.seed(13)

## Load libraries for the session ----

library(MASS)
library(tidyverse)
library(combinat)
library(snpStats)
library(parallel)

# Load functions ----

source("./DBF_test.R")

# Parameters index and set parameters ----
d.out <- args[2]
id.test <- as.numeric(args[1])
###
#d.out <- "./results"
#id.test <- 1
params <- readRDS("./tests.rds") %>% 
    filter(test.id == get("id.test"))


chr = params %>% pull(chromossome) %>% as.character()
index = params %>% pull(index) %>% as.character()
ncore = params %>% pull(ncore) %>% as.numeric()
# Import data ----

# Import microbiome data

list.data <- paste0("./microbiome.data/index", index, ".residuals.rds") %>% 
  readRDS()
cap.resid <- list.data$distance %>% as.matrix()
metadata <- list.data$metadata
#Import genotype data
file.core <- #"/home/lsilva/IKMB/projects/skin.mgwas/results/1.data.harmonization/2.genotype/PopGen_and_KORA.harmonized" %>% 
  "/work_ifs/sukmb447/projects/skin.mgwas/kora.popgen/PopGen_and_KORA.harmonized" %>% 
  paste0(".chr",chr)

plink <- read.plink(bed = paste0(file.core, ".bed"),
                    bim = paste0(file.core, ".bim"),
                    fam = paste0(file.core, ".fam"))

# Synchronize plink with metadata  ----

## Filter plink to match metadata ----

### Get files out of plink object ----

genotypes <- plink$genotypes
fam <- plink$fam
map <- plink$map

### Filter genotypes to match metadata ----

#check
checkpoint <- setdiff(metadata$Genotype_ID, rownames(genotypes)) %>% length()== 0
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}

#arrange
samples <- metadata$Genotype_ID
genotypes <- genotypes[metadata$Genotype_ID,]
fam <- fam[metadata$Genotype_ID,]

#Check
checkpoint <- identical(metadata$Genotype_ID, rownames(genotypes))
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}

checkpoint <- identical(metadata$Genotype_ID, rownames(fam))
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}

checkpoint <- identical(colnames(genotypes), rownames(map))
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}

checkpoint <- identical(metadata$NGS_ID, rownames(cap.resid %>% as.matrix))
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}

# Format genotype data ----

## Recode genotype data ids ----

#Because metadata microbiome data is coded using the 16S library names (NGS) and the genotype is coded using the individual names (Genotype_ID).

checkpoint <- identical(metadata$Genotype_ID, rownames(genotypes))
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}
checkpoint <- identical(metadata$Genotype_ID, rownames(fam))
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}

rownames(genotypes) <- metadata$NGS_ID
rownames(fam) <- metadata$NGS_ID

## Convert genotypes to numerics ----

genotypes <- as(genotypes, "numeric")

## Filter by frequency MAF < 2.5% ----

sub <- colnames(genotypes)[colMeans(genotypes, na.rm=T)/2 > 0.025 & 
                             colMeans(genotypes, na.rm=T)/2 < 0.975 &
                             is.na(colMeans(genotypes, na.rm=T)) == F]
print(head(sub))

genotypes <- genotypes[, sub]
map <- map[sub, ]

# ## Filter to make for standardization!!!!!! ----
# 
# sub <- colnames(genotypes)[1:20]
# genotypes <- genotypes[,sub]
# map <- map[sub,]

# Pre-processing ----

## Pre-fill output ----

out <- data.frame(map, tax=NA, n=NA, AA=NA, AB=NA, BB=NA, stat=NA, P=NA)
colnames(out) <- c("chr",
                   "snp.name",
                   "cM", 
                   "position", 
                   "A",
                   "B", 
                   "tax",
                   "n", 
                   "AA",
                   "AB", 
                   "BB",
                   "stat",
                   "P")
out$tax="bray"

## Set function to test each SNP ----

calculate.snp <- function(snp){
  #Function that performs some checking and apply the test of equality
  
  # Filter genotypes that are NA
  thisgt <- as(genotypes[,snp],"numeric")
  thisgt.sub <- thisgt[!is.na(thisgt)]
  
  # Perform calculation if heterozygotes and there is more than 100 subjects
  if(length(unique(thisgt.sub)) > 1 & length(thisgt.sub) > 100){
    # Match distance with the valid subjects
    thisdmat <- cap.resid[names(thisgt.sub),names(thisgt.sub)]
    #Get some stats
    thisn <- nrow(thisdmat)
    thisgtdist <- as.numeric(table(factor(thisgt,levels=c(0,1,2))))
    
    #apply DBF test of equality between groups:
    thisdbf <- DBF.test(dmat = thisdmat, group.labels = thisgt.sub, n = length(thisgt.sub))
    
    # save results
    res <- c(thisn, as.numeric(thisgtdist),as.numeric(thisdbf))
  }else{
    res<-rep(NA,6)}
  
  #add names to the results
  names(res)<-c("n","AA","AB","BB","stat","P")
  
  #Return results
  return(res)
}

# Perform test ----

#Test SNPs in paralell

system.time(f <- mclapply(as.list(sub), calculate.snp, mc.cores=ncore))
# organize results in a data.frame
out[,c("n","AA","AB","BB","stat","P")] <- data.frame(do.call(rbind, f))

# Save output ----
dir.create(d.out, showWarnings = F)
paste0(d.out, "/","test", id.test, ".", "index", index, ".", "chr", chr, ".betatests", ".rds") %>% 
  saveRDS(out, .)

# Session information ----

sessionInfo()

