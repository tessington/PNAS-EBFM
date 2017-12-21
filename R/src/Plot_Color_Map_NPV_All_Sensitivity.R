# Source file to plot the percent loss of cod NPV from applying harvest  rate trajectory from 
# each assumed (columns) into each true state of nature (rows).  
# Presently used for main manuscript figure
# Last Updated, 8/15/2017

rm(list = ls())

require(RColorBrewer)

wd <- '/Users/essing/Dropbox/Desktop/Rcode/EggPredationModel'
setwd(wd)

addalpha <- function(colors, alpha=1.0) {
  r <- col2rgb(colors, alpha=T)
  # Apply alpha
  r[4,] <- alpha*255
  r <- r/255.0
  return(rgb(r[1,], r[2,], r[3,], r[4,]))
}

colorRampPaletteAlpha <- function(colors, n=32, interpolate='linear') {
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



datadirs <- c('data/optimization_output_summer_2016','data/Sensitivity_Diets','data/Sensitivity_Discount07','data/Sensitivity_Prices')

plotfilename <- "NPV.Plots.Sensitivity.All.2.pdf"

setwd("./graphics")
pdf(file = plotfilename,
    height = 8,
    width = 12)
setwd("..")
nf = layout(matrix(c(1,	1,1,1,2,2, 2,2,	10,	5,	5, 5,5,	6,6,6,6, 
                     1,	1,1,1,2,2, 2,2,	10,	5,	5, 5,5,	6,6,6,6, 
                     1,	1,1,1,2,2, 2,2,	10,	5,	5, 5,5,	6,6,6,6, 
                     1,	1,1,1,2,2, 2,2,	10,	5,	5, 5,5,	6,6,6,6, 
                    3,	3,	3,3, 4,	4,	4, 4,10,	7,	7,	7,7, 8,	8, 8,8,
                    3,	3,	3,3, 4,	4,	4, 4,10,	7,	7,	7,7, 8,	8, 8,8,
                    3,	3,	3,3, 4,	4,	4, 4,10,	7,	7,	7,7, 8,	8, 8,8,
                    3,	3,	3,3, 4,	4,	4, 4,10,	7,	7,	7,7, 8,	8, 8,8,
                    9,	9,	9,	9,	9,	9,	9,	9,	9, 9, 9, 9, 9,9,9,9,9,
                    9,	9,	9,	9,	9,	9,	9,	9,	9, 9, 9, 9, 9,9,9,9,9),
  byrow = TRUE,
  nrow = 10,
  ncol = 17
))
par(mar = c(1, 1, 1, 1),
    omi=c(1,1,1,1),
    las = 1)

min.NPV <- -25
max.NPV <- 2.0
txt.mult <- 1.75

for (SENS in 3:4) {
  
  datadir <- datadirs[SENS]
  setwd(paste("./",datadir,sep = ""))
  highhigh <- read.csv(file = 'NPV_output_Case1.csv', header = F)
  highlow <- read.csv(file = 'NPV_output_Case2.csv', header = F)
  lowhigh <- read.csv(file = 'NPV_output_Case3.csv',  header = F)
  lowlow <- read.csv(file = 'NPV_output_Case4.csv',  header = F)
  setwd(wd)
  Iflip <- matrix(0, nrow = 4, ncol = 4)
  Iflip[4, 1] = 1
  Iflip[3, 2] = 1
  Iflip[2, 3] = 1
  Iflip[1, 4] = 1
  
  
  output.2.use <- c("highhigh", "highlow", "lowhigh", "lowlow")
  for (i in 1:length(output.2.use)) {
    eval.text <- paste("output<-", output.2.use[i])
    eval(parse(text = eval.text))
    pos.list <- which(output > max.NPV)
    output = replace(as.matrix(output), pos.list, max.NPV)
    # swap out really negative losses with a single big number, -50
    really.neg.list <- which(output <= min.NPV)
    output <- (replace(as.matrix(output), really.neg.list, min.NPV))
    flipped.mat <- (t(output) %*% Iflip)
    #flipped.mat<-t(output)
    
    image(
      seq(1:4),
      seq(1:4),
      (flipped.mat),
      ylab = "",
      xlab = "",
      zlim = c(min.NPV, max.NPV),
      axes = FALSE,
      col = col.palette.neg
    )
    box()
    if (i %in% c(1,2)) {
    axis(
      3,
      at = seq(1, 4),
      labels = c("I", "+P", "+E", "+D"),
      cex.axis = txt.mult
    )
    }
    if (i %in% c(1,3)) {
    axis(
      2,
      at = seq(1, 4),
      labels = c("+D", "+E", "+P", "+I"),
      cex.axis = txt.mult
    )
    }
  }
}

# make colorbar along the bottom

NPV.index.list <- seq(min.NPV / 100, max.NPV / 100, by = .02)
NPV.colors <-
  colorRampPaletteAlpha(color.alpha.neg, n=length(NPV.index.list), interpolate = "linear")

par(mai = c(0.5, 2, .0,2), xpd = TRUE)
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
NPV.plot.list.lab <- c(paste("<", min.NPV, sep = ""), -20, -15,-10,-5,0)
NPV.plot.list <- c(seq(min.NPV, 0, by = 5))
par(xpd = TRUE)
text(
  y = rep(0.0, length(NPV.plot.list)),
  x = NPV.plot.list / 100,
  labels = NPV.plot.list.lab,
  pos = 3,
  cex = txt.mult
)
text(
  y = -0.3,
  x = mean(c(min.NPV / 100, max.NPV / 100)),
  labels = "Change (%) in Net Present Value",
  pos = 1,
  cex = txt.mult
)

dev.off()
setwd("./graphics")
system2("open", args = c("-a Skim.app", plotfilename))
setwd(wd)
