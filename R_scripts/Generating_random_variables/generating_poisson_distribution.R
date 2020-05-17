# we apply the inverse transformtion technique with a recursive 
# search to generate a values from a Poisson distribution

rPoisson<-function(n,lambda=1)
{
 
  # initialize x
  x<-numeric(n)
  # numeric vector of n zeros
  u<-runif(n)
  
  for ( k in 1:n)
  {
    prob<-exp(-lambda)
    cum.prob<-prob
    while( u[k]>cum.prob )
    {
      x[k]<-x[k]+1
      prob<-prob*lambda/x[k]
      cum.prob<-cum.prob+prob
    }
    
  }
  return(x)
}

# generate sample(n=7) from Poisson Distribution (lambda=3)
rPoisson(7,3)

# below we compare the runtime of
# our function rPoisson and the R function rpois

set.seed(100)
system.time(
  PoissonSample<-rPoisson(10000,25)
)
set.seed(100)
system.time(
  rpois(10000,25)
)
