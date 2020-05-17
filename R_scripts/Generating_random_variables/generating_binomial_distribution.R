## generate a sample from a binomial 
## distribution with n=20, p=.20
Sample<-rbinom(10000,size=20,prob=.20)

# frequency table
table(Sample)
# bar plot 
plot(table(Sample),ylab="Frequency")
points(x=(0:9)+.15,
       dbinom(0:9,size=20,prob=.20)*10000,
       type="h",lty=2)

## table of the empirical distribution
p<-table(Sample)/10000
tProb<-dbinom(0:9,size=20,prob=.20)
se<-sqrt(p*(1-p)/10000)

probTable<-round(rbind(p,tProb,se),3)
probTable

