# this plots risk as the mean reduction from target, following Aven 2003

rm(list = ls())

library(RColorBrewer)

wd <- '/Users/essing/Dropbox/Desktop/Rcode/EggPredationModel'
setwd(wd)


datadir <- 'data/optimization_output_summer_2016'

Ctarget=1.133
Htarget=5

risk.calc <- function(x,beta)  -sum(x[x<0]^beta)/length(x)
  

row_names <- c("Cod", "Herring")
col_names <- c("Ind", "Pred", "Egg", "Dep")
dimnames = list(Species = row_names, Assumed = col_names)
risk.by.case <- list(highhigh = matrix(NA, nrow =2, ncol = 4,dimnames = dimnames),
                     highlow = matrix(NA, nrow = 2, ncol = 4,dimnames = dimnames),
                     lowhigh = matrix(NA, nrow = 2, ncol = 4,dimnames = dimnames),
                     lowlow = matrix(NA, nrow = 2, ncol = 4,dimnames = dimnames)
)
setwd(paste("./",datadir,sep = ""))
for (CASE in 1:4){
  for (SIM in 1:4){
    risk.count <- c(0,0)  
    for (FLAG in 1:4){
      filename=paste('output_sim_',CASE,'_', FLAG,'_',SIM,'.csv',sep="")
      eval(parse(text=paste('data','<-read.csv(file=','\"',filename,'\"', ",header = F)",sep="")))
      finalBs<-data[nrow(data),2:3]
      B2target<-100*finalBs/c(Ctarget,Htarget)-100
     # for (i in 1:2) {
    #    if (B2target[i]<=risk.thresh) risk.count[i]<- risk.count[i]+1
    #  }
      for (i in 1:2) {
        risk.count[i] <- risk.calc(B2target[i],beta = 1 ) * 0.25
      }
    }
    risk.by.case[[CASE]][1:2,SIM] <- risk.count
  }
}



# now get NPV
# now cod
chighhigh <- read.csv(file = 'cNPV_raw_Case1.csv', header = F)*0.006
chighlow <- read.csv(file = 'cNPV_raw_Case2.csv', header = F)*0.006
clowhigh <- read.csv(file = 'cNPV_raw_Case3.csv',  header = F)*0.006
clowlow <- read.csv(file = 'cNPV_raw_Case4.csv', header = F)*0.006

hhighhigh <- read.csv(file = 'hNPV_raw_Case1.csv', header = F)*0.006
hhighlow <- read.csv(file = 'hNPV_raw_Case2.csv', header = F)*0.006
hlowhigh <- read.csv(file = 'hNPV_raw_Case3.csv',  header = F)*0.006
hlowlow <- read.csv(file = 'hNPV_raw_Case4.csv', header = F)*0.006

#col <-
#  colorRampPalette(rev(brewer.pal(10, "RdBu")), interpolate = "spline")(8)[c(1,2, 6, 8)]
col <- viridis(n=16)[c(2,6,10,16)]
setwd(wd)
#### Make Plot #####
## a plot Expected Risk and Expected Opportunity, as in Aven 2003.

plotfilename <- "RiskandOpportunityBtarget.pdf"
setwd("./graphics")
pdf(plotfilename, height = 6.75, width = 9.5)
setwd(wd)
layout.mat <-matrix(
  c(rep(c(1,1,2,2,3,4,4,5,5),2),rep(6,9),rep(c(7,7,8,8,9,10,10,11,11),2)),
  nrow = 5,
  ncol = 9,
  byrow = T
) 
par(
  las = 1,
  omi = c(1.5, 1.5, 1.5, 1.5),
  mai = c(0.1, 0.1, .1, .1),
  xpd = TRUE
)
layout(layout.mat)
# this is risk threshold a X percent loss of min(NPVopt)
xlims <- rbind(c(0,25),c(0,25))
ylims <- rbind(c(0,30), c(0, 100))
species.list <- c("c","h")
caselist <- c("highhigh",'highlow',"lowhigh","lowlow")
for (CASE in 1:4) {
  for (spec in 1:length(species.list)) {
    species <- species.list[spec]
    eval(parse(text = paste("data.2.use<-as.matrix(",species,caselist[CASE],")", sep = "")))
   
    e.opportunity <- apply(data.2.use,FUN = mean, MARGIN = 2)
    e.risk <- eval(parse(text = paste("risk.by.case$",caselist[CASE],"[spec, ]",sep = "")))
   
    plot(e.risk, e.opportunity,
         col = col,
         xlim = xlims[spec,],
         ylim = ylims[spec,],
         type = "p",
         pch = 21,
         bg = col,
         cex = 2.0,
         yaxs= "i",
         xaxs = "i",
         axes = F)
    # Add tick marks only in first CASE
    if (CASE ==1 & spec ==1) {
      axis(side = 1, at = c(0,25), labels = F)
      axis(side = 2, at = c(0,30), labels = F)
      mtext(side = 1, at = 0, text = "0", line = 0.5, cex = 0.75)
      mtext(side = 1, at = 25, text = "25%", line = 0.5, cex = 0.75)
      mtext(side = 2, at = 30, text = "3", line = 0.5, cex = 0.75)
    }
    if (CASE == 1 & spec == 2) {
      axis(side = 1, at = c(0,25), labels = F, las = 1)
      axis(side = 4, at = c(0,100), labels = F)
      mtext(side = 1, at = 0, text = "0", line = 0.5, cex = 0.75)
      mtext(side = 1, at = 25, text = "25%", line = 0.5, cex = 0.75)
      mtext(side = 4, at = 100, text = "100", line = 0.5, cex = 0.75, las = 1)
      legend("bottomright",legend = c("Ind","+Pred", "+Egg", "+Dep"), pch = 21, pt.bg = col, pt.cex = 1.2, col = col, bty = "n")
    }
    if (!CASE == 1) {
    axis(side = 1, labels = F, tick = F)
    axis(side = 2, labels = F, tick = F)
    }
    
    box()
    par(las=0)
    if (spec == 1) {
     mtext(side =2, line = 1, text = "Expected NPV")
    mtext(side = 1, line =2, text = "Risk", at = 30)
    # plot legend in first
  if (CASE == 1) {
  
    mtext(
      side = 3,
      text = "Prey High",
      line = 2,
      cex = 1.5,
      at = 30
    )
    mtext(
      side = 2,
      text = "Piscivore High",
      line = 5,
      las = 0,
      cex = 1.5
    )
  }
    if (CASE == 2) {
      mtext(
        side = 3,
        text = "Prey Low",
        line = 2,
        cex = 1.5,
        at = 30
      )
    }
      if (CASE == 3) {
        mtext(
          side = 2,
          text = "Piscivore Low",
          line = 5,
          las = 0,
          cex = 1.5
        )
      }
  }
    }
  if (CASE < 4) plot.new() # make a blank plot, but not on last iteration
}

dev.off()
setwd('./graphics')
system2("open", args = c("-a Skim.app", plotfilename))
