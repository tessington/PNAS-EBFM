## Generate useful starting conditions (steady state) given some fishing history
library(rootSolve)

# set working directory
wd='/Users/essing/Dropbox/Desktop/Rcode/EggPredationModel/src'
setwd(wd)

scenario<-1 # set scenario 1= Independent, 2 = + Pred, 3 + Egg Pred, 4= + Depensation


source("delaydifferentialFN.R")

input.pars<-list(r=0.7,K=10,M2j=0.8,fprime=685,a=6.1e-4,b=2.93e-7,
                 theta=0.65,Cmax=5.88,p=.25,winf.star=0.02,
                 wr=0.005,d=0.75,M2=0.2,t.juv=4,fraction.egg.mort=0.0,
                 b.egg.pred.mult=0,DC.herring=0.0001,g=0)


if (scenario>=2) input.pars$DC.herring=0.25
if (scenario>=3) input.pars$fraction.egg.mort=0.25
if (scenario==4) input.pars$b.egg.pred.mult=15


INITCOND<-matrix(NA,nrow=4,ncol=3)

F1<-0.05
F2<-.05
ss<-uniroot.all.t(delay.differential.eq,c(0.0000,10),input.pars=input.pars,F1=F1,F2=F2)
x2<-max(ss)
soln<-solve.x1.n1(x2,input.pars,F1,F2)
x1<-soln$x1
n2<-soln$n2
print(c(x1,x2,n2))
INITCOND[1,]<-c(x1,x2,n2)

F1<-0.6
F2<-0.00
ss<-uniroot.all.t(delay.differential.eq,c(0.0000,10),input.pars=input.pars,F1=F1,F2=F2)
x2<-max(ss)
soln<-solve.x1.n1(x2,input.pars,F1,F2)
x1<-soln$x1
n2<-soln$n2
print(c(x1,x2,n2))
INITCOND[2,]<-c(x1,x2,n2)

F1<-0.05
F2<-0.35 # or use 0.3 for less severe
ss<-uniroot.all.t(delay.differential.eq,c(0.0000,10),input.pars=input.pars,F1=F1,F2=F2)
x2<-max(ss)
soln<-solve.x1.n1(x2,input.pars,F1,F2)
x1<-soln$x1
n2<-soln$n2
print(c(x1,x2,n2))
INITCOND[3,]<-c(x1,x2,n2/2)

F1<-0.6
F2<-0.35 # or use 0.3 for less severe
ss<-uniroot.all.t(delay.differential.eq,c(0.0000,10),input.pars=input.pars,F1=F1,F2=F2)
x2<-max(ss)
soln<-solve.x1.n1(x2,input.pars,F1,F2)
x1<-soln$x1
n2<-soln$n2
print(c(x1,x2,n2))
INITCOND[4,]<-c(x1,x2,n2/2)