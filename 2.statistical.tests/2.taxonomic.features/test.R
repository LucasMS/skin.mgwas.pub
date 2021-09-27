#####
#"Test effects with taxonomic features"#
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
library(snpStats)
library(parallel)
library(phyloseq)
library(mvabund)


# Parameters index and set parameters ----
d.out <- args[2]
id.test <- as.numeric(args[1])
###
#d.out <- "./results"
#id.test <- 10
params <- readRDS("./tests.rds") %>% 
  filter(test.id == get("id.test"))


level = params %>% pull(level) %>% as.character()
tax = params %>% pull(tax) %>% as.character()
index = params %>% pull(index) %>% as.character()
ncore = params %>% pull(ncore) %>% as.numeric()

# Import data ----

# Import microbiome data

ps <- paste0("./microbiome.data/index", index, ".ps.rds") %>% 
  readRDS()

ps.r <- paste0("./microbiome.data/phyloseq.rarefied.rds") %>% 
  readRDS()

# Select metadata
testdata <- ps %>% sample_data() %>% data.frame() %>% select(Age, Sex, BMI, PCA1, PCA2, PCA3, PCA4, PCA5, PCA6, PCA7, PCA8, PCA9, PCA10, Genotype_ID)

# Add tax data
e <- paste0(level, "==", "'",tax, "'")

tax.data <- ps %>% tax_glom(level) %>% subset_taxa(eval(parse(text = e)))
testdata$tax <- otu_table(tax.data)@.Data
tax.name <- tax_table(tax.data)@.Data %>% data.frame(stringsAsFactors = F) %>% select_if(~ !any(is.na(.))) %>% .[1,] %>% paste(collapse = ";")
# Add check

checkpoint <- identical(rownames(testdata), rownames(otu_table(tax.data)@.Data))
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}
#Get tax data for rarefied data
index.i <- index
testdata.r <- ps.r %>% subset_samples(index == index.i) %>% 
  tax_glom(level) %>% 
  subset_taxa(eval(parse(text = e))) %>%
  otu_table() %>% 
  .@.Data %>% 
  data.frame()
colnames(testdata.r) = "tax"
rm(index.i)

checkpoint <- identical(rownames(testdata.r), rownames(testdata))
if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}

# add offsets
testdata$library.size = sample_sums(ps)

# Get zero-truncated abundance of bacterial features based on the full data
zero.trunc <- testdata$tax > 0

# Update rarefied on zero-truncated
testdata.r <- testdata.r[zero.trunc,, drop = FALSE]

# Filter rarefied for extreme outliers deviating more than 5× the interquartile range (IQR) from the median abundance.
# These are calculated based on rarefied data to account for normalization.
med <- median(testdata.r$tax)
qt <- quantile(testdata.r$tax, c(0.25,0.75))
iqr <- qt[2] - qt[1]
testdata.r <- testdata.r[testdata.r$tax < (med + 5*iqr),, drop = FALSE]

# Remove samples from full data based on samples removed on rarefied data
testdata <- testdata[rownames(testdata) %in% rownames(testdata.r), ]

# Keep only complete cases
testdata <- testdata[complete.cases(testdata),]

print(paste("index", index, "level", level, "tax", tax, "nrow", nrow(testdata)))

# Fit GLM with count abundance
dd <- manyglm(tax ~ Age + Sex + BMI + PCA1 + PCA2 + PCA3 + PCA4 + PCA5 + PCA6 + PCA7 + PCA8 + PCA9 + PCA10 + offset(log(library.size)),
              data=testdata,
              family = "negative.binomial")
print(dd)


testdata$resid <- residuals(dd)

# Set functions

## Set function function to get lm results


test.lm <- function(df){
  # Get linear model
  lm.mod <- lm(resid ~ gt , data=df)
  # Get p.value and coefs
  lm.res <- summary(lm.mod)$coefficients[2,] %>% data.frame()
  # Get get confidence interals
  lm.res.int <- confint(lm.mod)[2,] %>% data.frame()
  lm.res.final <- rbind(lm.res, lm.res.int) %>%
    t() %>%
    data.frame() %>%
    .[,c(1,2,5,6,3,4)]
  return(lm.res.final)
}


## Set function to test each SNP ----


calculate.snp <- function(snp){
  #Function that performs some checking and apply the test
  
  # Filter genotypes that are NA
  thisgt <- as(genotypes[,snp],"numeric")
  thisgt.sub <- thisgt[!is.na(thisgt)]
  
  # test data with the valid subjects
  
  df <- data.frame(Genotype_ID = names(thisgt.sub), gt = thisgt.sub)
  df <- merge(df, testdata, by = "Genotype_ID", all.x = F, all.y = F) %>% 
    select(Genotype_ID, resid, gt)
  
  # make sure the cases are complete
  df <- df[complete.cases(df),]
  
  
  # Perform calculation if heterozygotes and there is more than 100 subjects
  if(length(unique(df$gt)) > 1 & nrow(df) > 100){
    
    #Get some stats
    thisn <- nrow(df)
    thisgtfreq <- df$gt %>% factor(levels=c(0,1,2)) %>% 
      table()
    
    #apply test:
    lm.res <- tryCatch(test.lm(df),
                       error = function(x) return(rep(NA,6)))
    
    # save results
    res <- c(thisn,
             thisgtfreq %>% as.numeric,
             lm.res %>% as.numeric())
  }else{
    res <-rep(NA,10)}
  
  #add names to the results
  names(res) <- c("n","AA","AB","BB","Beta","StdErr","Conf2.5", "Conf97.5", "Z","P")
  
  #Return results
  return(res)
}



# Perform tests for all variants in each chromossome

for(chr in 1:22){
  
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
  checkpoint <- setdiff(testdata$Genotype_ID, rownames(genotypes)) %>% length()== 0
  if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}
  
  #arrange
  samples <- testdata$Genotype_ID
  genotypes <- genotypes[testdata$Genotype_ID,]
  fam <- fam[testdata$Genotype_ID,]
  
  #Check
  checkpoint <- identical(testdata$Genotype_ID, rownames(genotypes))
  if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}
  
  checkpoint <- identical(testdata$Genotype_ID, rownames(fam))
  if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}
  
  checkpoint <- identical(colnames(genotypes), rownames(map))
  if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}
  
  
  # Format genotype data ----
  
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
  # sub <- colnames(genotypes)[1:500]
  # genotypes <- genotypes[,sub]
  # map <- map[sub,]
  
  # Pre-processing ----
  
  ## Pre-fill output ----
  
  out <- data.frame(map,
                    tax=NA,
                    n=NA,
                    AA=NA,
                    AB=NA,
                    BB=NA,
                    Beta=NA,
                    StdErr=NA,
                    Conf2.5 = NA,
                    Conf97.5 = NA,
                    Z=NA,
                    P=NA)
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
                     "Beta",
                     "StdErr",
                     "Conf2.5",
                     "Conf97.5",
                     "Z",
                     "P")
  out$id.test <- id.test
  out$level <- level
  out$tax <- tax
  out$tax.name <- tax.name
  
  
  # Perform test ----
  
  #Test SNPs in paralell
  
  system.time(f <- mclapply(as.list(sub), calculate.snp, mc.cores=ncore))
  
  # Check point
  
  checkpoint <- identical(length(f), nrow(out))
  if(!checkpoint){quit()}else{print("ok");rm(checkpoint)}
  
  # organize results in a data.frame
  out[,c("n","AA","AB","BB","Beta","StdErr","Conf2.5", "Conf97.5", "Z","P")] <- data.frame(do.call(rbind, f))
  
  
  # Save output ----
  dir.create(d.out, showWarnings = F)
  paste0(d.out, "/","test", id.test, ".", "index", index, ".", "chr", chr, ".taxtests", ".rds") %>% 
    saveRDS(out, .)
  
}


# Session information ----

sessionInfo()

