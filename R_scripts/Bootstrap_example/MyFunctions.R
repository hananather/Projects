# this is based on Professor Giles Lamothe lecture notes 
# for MAT 4374 at Universtiy of Ottawa 

my.mean<- function(x,digits=3,round=TRUE) {
  # omit missing values
  x<-x[!is.na(x)]
  if (round)
  { 
    result<-round(mean(x),digits) 
    }
  else { 
    result<-mean(x)  
    }

  return(result) 
}

my.sd<- function(x,digits=3,round=TRUE) {
  # omit missing values
  x<-x[!is.na(x)]
  if (round) {
    result<-round(sd(x),digits) 
    }
  else { 
    result<-sd(x)  
    }

  return(result) 
}

## no rounding for sample size
my.size<- function(x) {
  # omit missing values
  x<-x[!is.na(x)]
  result<-length(x)
  return(result) 
}

my.mean.tr<- function(x,digits=3,round=TRUE,trim=0.2) {
  # omit missing values
  x<-x[!is.na(x)]
  if (round) { 
    result<-round(mean(x,trim=0.2),digits) 
    }
  else { 
    result<-mean(x,trim=0.2)  
    }
  
  return(result) 
}

require(WRS2)
my.win.sd<- function(x,digits=3,round=TRUE,trim=0.2) {
  # omit missing values
  x<-x[!is.na(x)]
  if (round) { 
    result<-round(sqrt(winvar(x,tr=0.2)),digits) 
    }
  else { 
    result<-sqrt(winvar(x,tr=0.2))  
    }
  
  return(result) 
}

