## this script will: 
## generate a random vector from a multivariate normal distribution
## diagonalize a symmetric matrix to compute the 
## square of a variance-covariance matrix

## initialize variance-covariance matrix
Cov<-matrix(c(5,1.2,.5,1.2,6,-.6,.5,-0.6,7),
            byrow=TRUE,ncol=3)
Cov
is.matrix(Cov)

## eigen decomposition of matrix.
e<-eigen(Cov)
sr.Cov<-e$vectors %*% diag(sqrt(e$values)) %*% t(e$vectors)

# we can check to see if our matrix decompostion is correct the
# output should be our orginal variance-covariance matrix
sr.Cov %*% sr.Cov

## vector of means
##  linear transformation of independent normal random variables has a multivariate normal distribution
Mean<-matrix(c(10,15,20),ncol=1)


## generate a random vector from a multivariate normal distribution

## we want m= 5000 replications
m<-5000
d<-3
z<-matrix(rnorm(m*d),ncol=d,nrow=m)
J<-matrix(c(1),ncol=1,nrow=m) 
X.Sample<-z %*% sr.Cov+J %*% t(Mean)

## install package once: install.packages("psych")
## load the package
library(psych)
par(mfrow=c(1,1))
pairs.panels(X.Sample,
             method = "pearson", # correlation method
             hist.col = "#00AFBB",
             density = TRUE,  # show density plots
             ellipses = TRUE # show correlation ellipses
)






