# DESeq2 routine
dseq.routine <- function(f.full, f.null){
  
  dds <- DESeqDataSetFromMatrix(countData = micro.t,
                                colData = pheno,
                                design = f.full)
  dds <- DESeq(dds, sfType = "poscounts", reduced = f.null, test = "LRT", fitType = "parametric")
  
  if(pheno %>% pull(i) %>% is.character()){
    contrast <- c(i, pheno %>% pull(i) %>% unique() %>% sort() %>%  tail(2) %>% rev())
    res <- results(dds,  contrast = contrast, independentFiltering = F)
    res <- lfcShrink(dds,
                     res = res,
                     contrast = contrast,
                     type = "normal") %>%
      data.frame %>% 
      rownames_to_column("ASV") %>% 
      mutate(coefficient = paste(contrast, collapse = "_"))
  }else{
    res <- results(dds, name = i, independentFiltering = F)
    res <- lfcShrink(dds,
                     res = res,
                     coef =  resultsNames(dds) %>% tail(1),
                     type = "normal") %>% 
      data.frame %>% 
      rownames_to_column("ASV") %>% 
      mutate(coefficient = resultsNames(dds) %>% tail(1))
  } 
  return(res)
}

