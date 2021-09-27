#Adonis2 routine
adonis.routine <- function(f){
  require(vegan)
  res <- adonis2(f, data = pheno, permutations = 999, by = "terms", parallel = nc) %>%
    data.frame() %>% 
    rownames_to_column("x") %>% 
    rename("p.value" =  "Pr..F.") %>% 
    rename("term" = "x")  %>% 
    filter(term == i) 
  return(res)}
