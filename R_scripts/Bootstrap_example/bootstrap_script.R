# this is an example based on Professor Giles Lamothe lecture notes 
# for MAT 4374 at Universtiy of Ottawa 

# Import data from SENIC.csv
## We want to describe the length of stay according to region
## The statistical units are hospitals

senic<-read.csv(file.choose())
head(senic)

levels(senic$Region)

## change the labels of the levels
senic$Region<-factor(senic$Region,labels=c("NE","NC","S","W"))

levels(senic$Region)


## source MyFunctions.R
source(file.choose())

library(plyr)
ddply(senic, .(Region), summarise,
      mean=my.mean(length.of.stay),
      StDev=my.sd(length.of.stay),
      n=my.size(length.of.stay))


## comparative boxplot
library(ggplot2)
p<-ggplot(senic, aes(x=Region,y=length.of.stay)) +  
  geom_boxplot(color="gray") + geom_jitter(height=0,width=0.2) +
  theme_bw() +
  
  labs(title="Comparative boxplots",
       subtitle="Length of stay according to region",x ="Region",
       y = "Length of stay (in days)")
p


model<-lm(length.of.stay~Region,data=senic)
anova(model)

## reasonable to assume equal variance?
library(car)
leveneTest(model)

## reasonable to assume normality?
qqPlot(rstudent(model))
shapiro.test(rstudent(model))


### We will use Robust Statistics
### .2-trimmed means, .2-Windsorized std. dev

## source MyFunctions.r
source(file.choose())
library(plyr)
ddply(senic, .(Region), summarise,
      tr.mean=my.mean.tr(length.of.stay),
      Win.StDev=my.win.sd(length.of.stay),
      n=my.size(length.of.stay))


######################################
######################################
## Welch's heteroscedastic F test with trimmed means and Winsorized variances
## (Makes no assumption on the shape of the distributions)
## install.packages("onewaytests")
library(onewaytests)
welch.test(length.of.stay~Region,data=senic,rate=0.2)


###########################################
###########################################
### Conduct the Robust Welch Test as a permutation test

dim(senic)
factorial(113)
## It will be impossible to generate all possible permutations of the rows
## We will compute a Monte-Carlo p-value.

require(onewaytests)
welch.test.stat<-function(formula,data)
{
  
  welch.test(formula=formula,data=data,
             rate=0.2,verbose = FALSE)$statistic
  
}

B<-2000
n<-nrow(senic)
statistic<-welch.test(length.of.stay~Region,data=senic,rate=0.2)$statistic
F.star<-numeric(B)
senic.perm<-senic
perm<-function() {
  ## sample the indices without replacement
  indices<-sample(1:n)
  senic.perm$length.of.stay<-senic$length.of.stay[indices]
  return(welch.test.stat(length.of.stay~Region,senic.perm))
  }
Results<-replicate(B,perm())
p.value<-(1+sum(Results>=statistic))/(1+B)


### multiple comparison
library(WRS2)
library(plyr)



max.t.stat<-function(data) {
  ## data[,1] is response
  ## data[,2] is explanatory variable
  tr.means<-tapply(data[,1],data[,2],my.mean.tr)
  win.sd<-tapply(data[,1],data[,2],my.win.sd)
  sizes<-tapply(data[,1],data[,2],my.size)
  # size after trimming=h
  h<-sizes-2*floor(sizes*.2)
  d<-(sizes-1)*win.sd^2/(h*(h-1))
  # number of group=r
  r<-length(tr.means)
  index<-1:r
  num.comparison<-choose(r,2)
  names.com<-
    t<-numeric(num.comparison)
  i<-1
  for (k in 1:(r-1)) {
    
    index<-index[-1]
    remaining<-length(index)
    for (l in index) {
      
      t[i]<-(tr.means[k]-tr.means[l])/sqrt(d[k]+d[l])
      i<-i+1
    }
  }
  return(max(abs(t)))
  
}

pairwise.t.stat<-function(data) {
  ## data[,1] is response
  ## data[,2] is explanatory variable
  
  # modify the functions in MyFunctions.r
  # for no rounding
  my.mean.trim<-function(x) { my.mean.tr(x,round=FALSE) }
  my.wins.sd<-function(x) { my.win.sd(x,round=FALSE) }
  
  tr.means<-tapply(data[,1],data[,2],my.mean.trim)
  win.sd<-tapply(data[,1],data[,2],my.wins.sd)
  sizes<-tapply(data[,1],data[,2],my.size)
  
  # size after trimming=h
  h<-sizes-2*floor(sizes*.2)
  d<-(sizes-1)*win.sd^2/(h*(h-1))
  # number of group=r
  r<-length(tr.means)
  index<-1:r
  num.comparison<-choose(r,2)
  names.com<-
    t<-numeric(num.comparison)
  names(t)<-character(num.comparison)
  i<-1
  for (k in 1:(r-1)) {
    index<-index[-1]
    remaining<-length(index)
    for (l in index) {
      t[i]<-(tr.means[k]-tr.means[l])/sqrt(d[k]+d[l])
      names(t)[i]<-paste(names(tr.means[k]),"-",names(tr.means[l]))
      i<-i+1
    }
  }
  return(t)
  
}



data.temp<-with(senic,
                data.frame(length.of.stay=length.of.stay,Region=Region))
max.t.stat(data.temp)

#### multiple comparisons as a Permutation Test

B<-2000
n<-nrow(senic)
statistic<-pairwise.t.stat(data.temp)
max.t.star<-numeric(B)
data.temp.perm<-data.temp
perm<-function() {
  ## sample the indices without replacement
  indices<-sample(1:n)
  data.temp.perm$length.of.stay<-data.temp$length.of.stay[indices]
  return(max.t.stat(data.temp.perm))
}

Results<-replicate(B,perm())
num.comparison<-length(statistic)

p.value<-numeric(num.comparison)
  for (i in 1:num.comparison) {
    p.value[i]<-(1+sum(Results>=statistic[i]))/(1+B)
}