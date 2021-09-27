# Function to calculate genomic inflation excluding regions of high LD

get.lambda <- function(p){
  lambda.i <- tryCatch(
    {
      #Method 1:
      l1 <- estlambda(p)
      
      #Method 2:
      l2 <- estlamb(p)
      
      data.frame(estimate.genAbel = l1$estimate,
                 se.genAbel = l1$se,
                 estimate.2 = l2)},
    error=function(e) {data.frame(estimate.genAbel = NA,
                                   se.genAbel = NA,
                                   estimate.2 = NA)}
    )
  return(lambda.i)
}
