# This is a function that is similar to image, but allows one to send two different color palletes, one for negative values and one for positive values
mod.image <- function (x = seq(0, 1, length.out = nrow(z)), y = seq(0, 1, length.out = ncol(z)), z, zlim = range(z[is.finite(z)]), 
          xlim = range(x), ylim = range(y), colpos,colneg,
          add = FALSE, xaxs = "i", yaxs = "i", xlab, ylab, axes) 
{
 # Function to plot "image" type plots but with more flexible control on scaling
  ncolors <- length(colpos)
  z.s.pos <- seq(0, zlim[2], length.out = ncolors)
  z.s.neg <- seq(zlim[1],0, length.out = ncolors)
  x.s <- seq.int(min(x),max(x))
  # make blank plot
  plot(c(), c(), xlim = c(xlim[1], xlim[2]+1), ylim = c(ylim[1], ylim[2]+1), axes = axes,ylab = ylab, xlab = xlab,xaxs = "i", yaxs = "i")
  
  for (i in 1:max(x)) {
    for (j in 1:max(y)) {
      ifelse(z[i,j]>=0,
      col.2.use <- colpos[which(z.s.pos >=z[i,j])[1]],
      col.2.use <- colneg[which(z.s.neg >=z[i,j])[1]])
      rect(xleft = x[i], xright = x[i]+1, ybottom = y[j], ytop = y[j]+1, col=col.2.use, border = NA)
    }
  }
  
}