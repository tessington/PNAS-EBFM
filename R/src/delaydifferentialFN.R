delay.differential.eq<-function(x2,input.pars,F1,F2) {
  pars<-unlist(input.pars)
  for (i in 1:length(pars)){
    assign(names(pars)[i],unname(pars[i]))
  }
  f=fprime*1000^2*0.5# fecundity in eggs per mt of total adult size (assume equal sex ratio)
  Metotal=0.2# total egg mortality rate, d^-1
  b.egg.pred<-(1/f)*b.egg.pred.mult
  alpha12.max=Metotal*fraction.egg.mort*(1+b.egg.pred*f)/(0.5*K)# alpha12.max is the maximum egg predation mortality when x1=0.5K and predators are very rare
  Te=20# duration of egg stage (days)
  Me=Metotal*(1-fraction.egg.mort)
  # predator parameters
  
  Y=Cmax*p*(1-DC.herring)/(1-p)
  alpha21=2*Cmax*DC.herring*p/(K*(1-p))
  
  H<-p*Cmax/(0.01^(d-1)) # von bertalanffy parameters
  vb.k<-(theta*H/(winf.star^(1-d))) # von bertalanffy parameters
  kappa<-exp(-vb.k)*(1-d) # this is an approximation, seems to work OK but slows down growth a bit
  Z2<-M2+F2
  
  #########################  
  
  # calculate Recruitment
  # J is number of post egg produced
  # Calculate x1
  a.tmp<--(r/K)*alpha21
  b.tmp=(-r/K)*(Cmax+Y)+(r-F1)*alpha21
  c.tmp<-(Cmax+Y)*(r-F1)-Cmax*alpha21*x2^(1+g)
  x1<-(-b.tmp-sqrt(b.tmp^2-4*a.tmp*c.tmp))/(2*a.tmp)
  
  # calculate new growth rate given x1.tmp
  if(any(is.na(x1))) x1=0
  x1.tmp=max(c(x1,0))
  x1.star<-x1.tmp
  J<-f*x2*exp(-(Me+(alpha12.max*x1.star/(1+b.egg.pred*f*x2)))*Te)
  R<-a*J/(1+b*J)*exp(-M2j*t.juv)
  
  # Predator total consumption / biomss
  Cons.tmp<-Cmax*(alpha21*x1.star*x2^g+Y)/(Cmax+alpha21*x1.star*x2^g+Y)
  H.tmp<-Cons.tmp/(0.01^(d-1))
  winf.tmp<-(theta*H.tmp/vb.k)^(1/(1-d))
  n2<-R/(Z2)
  dx2dt<-wr*R+kappa*winf.tmp*n2-(Z2+kappa)*x2
  return(dx2dt)
  
}

solve.x1.n1<-function(x2,input.pars,F1,F2) {
  pars<-unlist(input.pars)
  for (i in 1:length(pars)){
    assign(names(pars)[i],pars[i])
  }
  
   
  
  f=fprime*1000^2*0.5# fecundity in eggs per mt of total adult size (assume equal sex ratio)
  Metotal=0.033# total egg mortality rate, d^-1
  b.egg.pred<-(1/f)*b.egg.pred.mult
  alpha12.max=Metotal*fraction.egg.mort*(1+b.egg.pred*f)/(0.5*K)# alpha12.max is the maximum egg predation mortality when x1=0.5K and predators are very rare
  Me=Metotal*(1-fraction.egg.mort)
  Te=30# duration of egg stage (days)
  # predator parameters
  Y=Cmax*p*(1-DC.herring)/(1-p)
  alpha21=2*Cmax*DC.herring*p/(K*(1-p))
  
  Z2<-M2+F2
  #########################  
  a.tmp<--(r/K)*alpha21
  b.tmp=(-r/K)*(Cmax+Y)+(r-F1)*alpha21
  c.tmp<-(Cmax+Y)*(r-F1)-Cmax*alpha21*x2^(1+g)
  x1<-(-b.tmp-sqrt(b.tmp^2-4*a.tmp*c.tmp))/(2*a.tmp)
  if(is.na(x1)) x1=0
  x1<-max(0,x1)
  alpha12<-alpha12.max/(1+b.egg.pred*x2*f)
  J<-f*x2*exp(-(Me+alpha12*x1)*Te)
  R<-a*J/(1+b*J)*exp(-M2j*t.juv)
  # Predator total consumption / biomss
  n2.star<-R/(M2+F2)
  return(list(x1=x1,n2=n2.star))

}

# modified version of uniroot
uniroot.all.t<-function (f, interval, lower = min(interval),upper=max(interval), ...) 
{
  n=100
  if (!missing(interval) && length(interval) != 2) 
    stop("'interval' must be a vector of length 2")
  if (!is.numeric(lower) || !is.numeric(upper) || lower >= 
      upper) 
    stop("lower < upper  is not fulfilled")
  xseq <- seq(lower, upper, len = n + 1)
  mod <- sapply(X=xseq,FUN=f,...)
  Equi <- xseq[which(mod == 0)]
  ss <- mod[1:n] * mod[2:(n + 1)]
  ii <- which(ss < 0)
  for (i in ii) Equi <- c(Equi, uniroot(f,interval=c(xseq[i], xseq[i + 1]),...)$root)
  return(Equi)
}


stock.recruit<-function(input.pars,F1,F2,SSB.list){
  pars<-unlist(input.pars)
  for (i in 1:length(pars)){
    assign(names(pars)[i],pars[i])
  }
  
   f=fprime*1000^2*0.5# fecundity in eggs per mt of total adult size (assume equal sex ratio)
  Metotal=0.2# total egg mortality rate, d^-1
  b.egg.pred<-(1/f)*b.egg.pred.mult
  alpha12.max=Metotal*fraction.egg.mort*(1+b.egg.pred*f)/(0.5*K)# alpha12.max is the maximum egg predation mortality when x1=0.5K and predators are very rare
  Te=20# duration of egg stage (days)
  Me=Metotal*(1-fraction.egg.mort)
  # predator parameters
  w.ref=0.01
  Y=Cmax*p*(1-DC.herring)/(1-p)
  alpha21=2*Cmax*DC.herring*p/(K*(1-p))
  
  H<-p*Cmax/(0.01^(d-1)) # von bertalanffy parameters
  vb.k<-(theta*H/(winf.star^(1-d))) # von bertalanffy parameters
  kappa<-exp(-vb.k)*(1-d) # this is an approximation, seems to work OK but slows down growth a bit
  Z2<-M2+F2
  
#########################  
  
  
  n.SSB<-length(SSB.list)
  b.egg.pred<-(1/f)*b.egg.pred.mult
  alpha12.list<-alpha12.max/(rep(1,length(SSB.list))+b.egg.pred*SSB.list*f)
  x1.output<-rep(NA,n.SSB)
  R.var.x1<-rep(NA,n.SSB)    
  # Cycle through SSB calculate prey (x1) and recruitment
  SBPR.x1.var.list<-rep(NA,n.SSB)
  a.tmp<--(r/K)*alpha21
  b.tmp=(-r/K)*(Cmax+Y)+(r-F1)*alpha21
  
  RPSB<-rep(NA,n.SSB)
  for (i in 1:n.SSB){
    x2<-SSB.list[i]
    c.tmp<-(Cmax+Y)*(r-F1)-Cmax*alpha21*x2^(1+g)
    x1.tmp<-(-b.tmp-sqrt(b.tmp^2-4*a.tmp*c.tmp))/(2*a.tmp)
    # calculate new growth rate given x1.tmp
    if(is.na(x1.tmp)) x1.tmp=0
    x1.tmp=max(c(x1.tmp,0))
    R.var.x1[i]<-f*SSB.list[i]*a*exp(-(Me+alpha12.list[i]*x1.tmp)*Te)/(1+b*f*SSB.list[i]*exp(-(Me+alpha12.list[i]*x1.tmp)*Te))*exp(-M2j*t.juv)
    n2<-R.var.x1[i]/(F2+M2)
    # Predator total consumption / biomss
    p.tmp<-(alpha21*x1.tmp+Y)/(Cmax+alpha21*x1.tmp+Y)
    H.tmp<-p.tmp*Cmax*(w.ref)^(1-d)
    winf.tmp<-(theta*H.tmp/vb.k)^(1/(1-d))
    xpr.tmp<-(wr+kappa*winf.tmp/Z2)/(Z2+kappa)
    RPSB[i]<-1/xpr.tmp
  }
  
  #Replacement Line
  Replace.var.x1<-SSB.list*RPSB
  return(list(Recruit=R.var.x1,Replace=Replace.var.x1))
}