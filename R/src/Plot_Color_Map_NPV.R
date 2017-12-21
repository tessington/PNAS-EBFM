# Source file to plot the percent loss of NPV from applying harvest  rate trajectory from 
# each assumed (columns) into each true state of nature (rows).  
# Presently used for main manuscript figure
# Last Updated, 2/27/2017

rm(list = ls())
wd <- '/Users/essing/Dropbox/Desktop/Rcode/EggPredationModel'
setwd(wd)

require(plotrix)
require(RColorBrewer)
#setwd("/Users/essing/Dropbox/Desktop/Rcode/timtools/R")
addalpha <- function(colors, alpha=1.0) {
  r <- col2rgb(colors, alpha=T)
  # Apply alpha
  r[4,] <- alpha*255
  r <- r/255.0
  return(rgb(r[1,], r[2,], r[3,], r[4,]))
}

# colorRampPaletteAlpha()
colorRampPaletteAlpha <- function(colors, n=32, interpolate='linear') {
  #  Special function for below 
 
  
    # Create the color ramp normally
  cr <- colorRampPalette(colors, interpolate=interpolate)(n)
  # Find the alpha channel
  a <- col2rgb(colors, alpha=T)[4,]
  # Interpolate
  if (interpolate=='linear') {
    l <- approx(a, n=n)
  } else {
    l <- spline(a, n=n)
  }
  l$y[l$y > 255] <- 255 # Clamp if spline is > 255
  cr <- addalpha(cr, l$y/255.0)
  return(cr)
}
setwd("./src")
source("makeimageFN.R")
setwd("..")



datadir <- 'data/optimization_output_summer_2016'

plotfilename <- "ALL.NPZ.Plots.pdf"

min.NPV <- -15
max.NPV <- 0
txt.mult = 2
setwd("./",datadir, sep = "")
highhigh <- read.csv(file =  'NPV_output_Case1.csv', header = F)
highlow <- read.csv(file = 'NPV_output_Case2.csv', header = F)
lowhigh <- read.csv(file = 'NPV_output_Case3.csv', header = F)
lowlow <- read.csv(file = 'NPV_output_Case4.csv', header = F)
setwd(wd)

print(lowhigh)
Iflip <- matrix(0, nrow = 4, ncol = 4)
Iflip[4, 1] = 1
Iflip[3, 2] = 1
Iflip[2, 3] = 1
Iflip[1, 4] = 1


# Set Color Pallettes
color.list.neg <- rep(brewer.pal(10,"RdYlBu")[1],11)
alpha.list <- c(exp(-seq(0,4,length.out = 10)),0)
color.alpha.neg<-rep(NA,11)
for (k in 1:11) color.alpha.neg[k] <- addalpha(color.list.neg[k],alpha.list[k])
col.palette.neg <-
  colorRampPaletteAlpha(color.alpha.neg, n=33, interpolate = "linear")

color.list.pos <- rep(brewer.pal(10,"RdYlBu")[10],11)
alpha.list <- rev(alpha.list)
color.alpha.pos<-rep(NA,11)
for (k in 1:11) color.alpha.pos[k] <- addalpha(color.list.pos[k],alpha.list[k])
col.palette.pos <-
  colorRampPaletteAlpha(color.alpha.pos, n=20, interpolate = "linear")


setwd("./graphics")
pdf(file = plotfilename,
    height = 10,
    width = 10)
output.2.use <- c("highhigh", "highlow", "lowhigh", "lowlow")
nf = layout(matrix(
  c(1, 2, 1, 2, 3, 4, 3, 4, 5, 5),
  byrow = TRUE,
  nrow = 5,
  ncol = 2
))
par(mar = c(2, 5, 2, 2),
    las = 1,
    omi = c(1, 1, 1, 1))
for (i in 1:length(output.2.use)) {
  eval.text <- paste("output<-", output.2.use[i])
  eval(parse(text = eval.text))
  pos.list <- which(output > max.NPV)
  output <-replace(as.matrix(output), pos.list, max.NPV)
  # swap out really negative losses with a single big number, -50
  really.neg.list <- which(output <= min.NPV)
  output <- (replace(as.matrix(output), really.neg.list, min.NPV))
  flipped.mat <- (t(output) %*% Iflip)
  #flipped.mat<-t(output)
  
  #col.palette <-
    #rev(colorRampPalette(viridis(n=15), interpolate = "spline")(15))

  image(
    x=seq(1:4),
    y=seq(1:4),
    z=flipped.mat,
    ylab = "",
    xlab = "",
    zlim = c(min.NPV, max.NPV),
    axes = FALSE,
    col = col.palette.neg
  )
  box()
  axis(
    3,
    at = seq(1.0, 4.0,by=1),
    labels = c("Ind", "Pred", "Egg", "Dep"),
    cex.axis = txt.mult
  )
  axis(
    2,
    at = seq(1.5, 4.5, by=1),
    labels = c("Dep", "Egg", "Pred", "Ind"),
    cex.axis = txt.mult
  )
  if (i == 1) {
    mtext(
      side = 3,
      text = "Prey High",
      line = 4,
      cex = txt.mult
    )
    mtext(
      side = 2,
      text = "Piscivore High",
      line = 5,
      las = 0,
      cex = txt.mult
    )
  }
  if (i == 2) {
    mtext(
      side = 3,
      text = "Prey Low",
      line = 4,
      cex = txt.mult
    )
  }
  if (i == 3) {
    mtext(
      side = 2,
      text = "Piscivore Low",
      line = 5,
      las = 0,
      cex = txt.mult
    )
  }
  
}


# make colorbar along the bottom

NPV.index.list <- seq(min.NPV / 100, max.NPV / 100, by = .01)
#NPV.index.list=round(100*NPV.index.list)/100
NPV.colors <-
  colorRampPaletteAlpha(color.alpha.neg, n=length(NPV.index.list), interpolate = "linear")

par(mai = c(0.5, 2, .5,2), xpd = TRUE)
plot(
  0,
  0,
  type = "n",
  xlim = c(min.NPV / 100, max.NPV / 100),
  ylim = c(0, .9),
  axes = FALSE,
  ylab = "",
  xlab = ""
)


# loop through colors, make squares
ymin <- 0.5
ymax <- 1.5

NPV.inc <- NPV.index.list[2]-NPV.index.list[1]
for (i in 1:length(NPV.index.list)){
  rect(xleft = NPV.index.list[i],xright = NPV.index.list[i]+NPV.inc*0.99,ybottom=ymin,ytop=ymax,col=NPV.colors[i],border=NA,lwd=0)
}

#gradient.rect( xleft= -0.15, xright = 0, ybottom = ymin, ytop = ymax, density = 0, col=NPV.colors, gradient = "x", border = NA)
#for (i in 2:length(NPV.index.list)) {
#  NPV.color <- NPV.colors[i - 1]
##  y <- c(ymin, ymax, ymax, ymin)
#  x <-
#    c(NPV.index.list[i - 1],
#      NPV.index.list[i - 1],
#      NPV.index.list[i],
#      NPV.index.list[i])
#  polygon(x, y, col = NPV.color, border = NPV.color)
#}

NPV.plot.list.lab <- c(paste("<", min.NPV, sep = ""), -10, -5,0)
NPV.plot.list <- c(seq(min.NPV, 0, by = 5))
par(xpd = TRUE)
text(
  y = rep(0.1, length(NPV.plot.list)),
  x = NPV.plot.list / 100,
  labels = NPV.plot.list.lab,
  pos = 3,
  cex = txt.mult
)
text(
  y = -0.1,
  x = mean(c(min.NPV / 100, max.NPV / 100)),
  labels = "Change (%) in Net Present Value",
  pos = 1,
  cex = txt.mult
)
dev.off()

system2("open", args = c("-a Skim.app", plotfilename))
setwd(wd)
