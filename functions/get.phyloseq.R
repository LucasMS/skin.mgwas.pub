# Conver micro, tax and metadatada/phenotype data to phyloseq object
get.phyloseq <- function(micro, tax, pheno){
  require(phyloseq)
  require(tidyverse)
  
  ## Re-order columns of tax
  
  tax <- tax %>%
    right_join(data.frame(ASV = colnames(micro)), by = "ASV") 
  
  identical(tax$ASV, colnames(micro)) %>% 
    print()
  
  tax <- tax %>% 
    select(Kingdom, Phylum, Class, Order, Family, Genus, Species, seqs, ASV)    
  rownames(tax) <- tax$ASV
  
  identical(colnames(micro), rownames(tax)) %>% print()
  
  # Process pheno
  
  rownames(pheno) <- pheno$NGS_ID
  
  ## Check compatibility
  
  identical(colnames(micro), rownames(tax)) %>% print()
  identical(rownames(micro), rownames(pheno)) %>% print()
  
  # Convert to phyloseq format
  
  
  tax.ps <- tax_table(tax %>% as.matrix())
  micro.ps <- otu_table(micro, taxa_are_rows = F)
  pheno.ps <- sample_data(pheno)
  
  # Combine data into a single object
  
  ps <- phyloseq(tax_table(tax.ps),  
                 otu_table(micro.ps, taxa_are_rows = F),
                 sample_data(pheno.ps))
  return(ps)
}
