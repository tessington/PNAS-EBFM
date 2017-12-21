# make basic stock-recruit plot for the four main scenarios
rm(list = ls())

wd = '/Users/essing/Desktop/Rcode/EggPredationModel'
setwd(wd)

setwd("./src")
source('delaydifferentialFN.R')
library(rootSolve)
library(RColorBrewer)
setwd("..")
stock.recruit.view =
  function(input.pars,
           F2,
           F1.list,
           lab = F,
           col.2.use = "red",
           y.ax.lab = T,
           x.ax.lab = T
           ) {
    SSB.list <- SSB.list <- seq(0.0001, 4, by = 0.001)
    
    for (i in 1:length(F1.list)) {
      F1 <- F1.list[i]
      
      sr <- stock.recruit(input.pars, F1, F2, SSB.list)
      Net.Prod <- sr$Recruit - sr$Replace
      
      if (i == 1) {
        plot(
          SSB.list,
          Net.Prod,
          type = "l",
          lwd = 2,
          ylim = c(-40, 40),
          axes = F,
          xaxs = "i",
          col = col.2.use[i],
          ylab = "",
          xlab = ""
        )
        abline(h = 0)
        box()
        axis.text <- NULL
        if (y.ax.lab) axis.text <- "Piscivore\nPopulation\nChange"
        par(las = 1)
        mtext(
          side = 2,
          text = axis.text,
          adj = c(0.5),
          line = 4,
          cex = 1.25
        )
        axis.text <- NULL
        if (x.ax.lab) axis.text <- "Piscivore Abundance"
        mtext(side = 1,
              text = axis.text,
              line = 1.5,
              cex = 1.25)
        
      } else {
        lines(SSB.list,
              Net.Prod,
              type = "l",
              lwd = 2,
              col = col.2.use[i])
      }
    }
  }
# Function to cycle through values of F to look at depenensatory equilibrium


input.pars <-
list(
  r = 0.7,
  K = 10,
  M2j = 0.8,
  fprime = 685,
  a = 6.1e-4,
  b = 2.93e-7,
  theta = 0.65,
  Cmax = 5.88,
  p = .25,
  winf.star = 0.02,
  wr = 0.005,
  d = 0.75,
  M2 = 0.2,
  t.juv = 4,
  fraction.egg.mort = 0.0,
  b.egg.pred.mult = 0,
  DC.herring = 0.0,
  g = 0
)

setwd("./graphics")
plotfilename <- "PiscivoreProduction2.pdf"
pdf(file = plotfilename,height = 8, width = 10)
setwd("..")
par(omi = c(1,1,1,1), mai = c(0.25,0.25,0.25,0.25),mfrow = c(2,2))
# vector of prey fishing rates
F1.list <- seq(0, 0.6, by = 0.05)
# predator fishing rate
  F2 <- 0.1
  
  colors.2.use <- colorRampPalette(rev(brewer.pal(11,"RdBu")),interpolate = "spline")(length(F1.list))
  
  stock.recruit.view(input.pars,
             F2,
             F1.list=0,
             lab = F,
             col.2.use = rep("black",length(F1.list)),
             y.ax.lab = T,
             x.ax.lab = F
             ) 
  input.pars$DC.herring <- 0.75
  stock.recruit.view(input.pars,
                     F2,
                     F1.list,
                     lab = F,
                     col.2.use = colors.2.use,
                     y.ax.lab = F,
                     x.ax.lab = F
                     ) 
  input.pars$fraction.egg.mort <- 0.25
  stock.recruit.view(input.pars,
                     F2,
                     F1.list,
                     lab = F,
                     col.2.use = colors.2.use,
                     y.ax.lab = T,
                     x.ax.lab = T
                    ) 
  
  input.pars$b.egg.pred.mult <- 15
  stock.recruit.view(input.pars,
                     F2,
                     F1.list,
                     lab = F,
                     col.2.use = colors.2.use,
                     y.ax.lab = F,
                     x.ax.lab = T
                    )
  
dev.off()
setwd("./graphics")
system2("open", args = c("-a Skim.app", plotfilename))
setwd(wd)
