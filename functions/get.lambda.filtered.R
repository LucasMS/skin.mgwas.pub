# Function to calculate genomic inflation excluding regions of high LD


get.lambda.filtered <- function(df, chr, position, p){
  
  to.remove <- data.frame(chr = c(5, 6, 8, 11),
                          from = c(44000000, 25000000, 8000000,45000000),
                          to = c(51500000, 33500000, 12000000, 57000000),
                          region = c("R1", "R2", "R3", "R4"))
  # Data provided by Frauke Degenhardt
  
  
  # df containing the columns chr, position and p (which are indicated by strings).
  # chr is assumed to be numeric
  require(tidyverse)
  # Require estimate lambda from 
  
  df <- df %>% 
    data.frame() %>% 
    # Select columns that matter
    select(all_of(chr), all_of(position), all_of(p)) %>% 
    # Rename them
    rename("position" = position,
           "chr" = chr,
           "p" = p) %>% 
    mutate(chr = chr %>% as.numeric(),
           position = position %>% as.numeric())
  
  # Filter using a loop
  for (i in 1:nrow(to.remove)){
    df <- df %>% 
      filter(!(chr == to.remove[i,1] & position > to.remove[i,2] & position < to.remove[i,3]))}
  
  P <- df$p
  
  lambda.i <- tryCatch(
    {
      #Method 1:
      l1 <- estlambda(P)
      l1 <- data.frame(estimate.filtered = l1$estimate,
                       se.filtered = l1$se)},
    error=function(e) {data.frame(estimate.filtered = NA,
                                  se.filtered = NA)}
  )
  return(lambda.i)
}
