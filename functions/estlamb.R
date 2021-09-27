#Function to estimate lambda from P-value

#source: https://www.biostars.org/p/43328/
#Author:aydzhouyuan https://www.biostars.org/u/11534/

estlamb <- function(p.value){
   z = qnorm( p.value / 2)

## calculates lambda
lambda = round(median(z^2, na.rm = T) / 0.454, 3)
return(lambda)
}
