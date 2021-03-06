#!/usr/bin/env Rscript

# Specify a blue->red colour gradient for the range [0,1] in 10 steps
colors<-paste0(colorRampPalette(c("blue","red"))(10),seq(0,100,length.out = 11))
colors[1]<-paste0(colors[1],"0") # Add opacity
colors[length(colors)]<- substr(colors[length(colors)],1,7) # Add opacity

# Define support functions
plotLDRegion<-function(dataSource, from, to, upper = FALSE, lower = FALSE, add = FALSE, ...){
  # Assumes all the data is from the same chromosome
  if(upper == TRUE){
    b<-dataSource[dataSource$POS_A >= from & dataSource$POS_A <= to & dataSource$POS_B >= from & dataSource$POS_B <= to & dataSource$POS_A < dataSource$POS_B,]
  } else if(lower == TRUE){
    b<-dataSource[dataSource$POS_A >= from & dataSource$POS_A <= to & dataSource$POS_B >= from & dataSource$POS_B <= to & dataSource$POS_B < dataSource$POS_A,]
  } else {
    b<-dataSource[dataSource$POS_A >= from & dataSource$POS_A <= to & dataSource$POS_B >= from & dataSource$POS_B <= to,]
  }
  b$R2[b$R2>1]<-1 # In cases of rounding error
  b<-b[order(b$R2,decreasing = F),] # sort for Z-stack
  if(add == TRUE){
    points(b$POS_A,b$POS_B,pch=20,cex=0.02,col=colors[cut(b$R2,breaks=seq(0,1,length.out = 11),include.lowest = T)], ...)
  } else {
    plot(b$POS_A,b$POS_B,pch=20,cex=0.02,col=colors[cut(b$R2,breaks=seq(0,1,length.out = 11),include.lowest = T)],xlim=c(from,to),ylim=c(from,to),xaxs="i",yaxs="i", ...)
    abline(0,1,lwd=2,col="grey")
  }
}

plotLDRegionTriangular<-function(dataSource, from, to, ...){
  # Assumes all the data is from the same chromosome
  b<-dataSource[dataSource$POS_A>=from & dataSource$POS_A<=to & dataSource$POS_B>=from & dataSource$POS_B<=to,]
  b<-b[b$POS_A<b$POS_B,] # upper triangular only
  b<-b[order(b$R2,decreasing = F),] # sort for Z-stack
  plot(b$POS_A + ((b$POS_B-b$POS_A)/2),b$POS_B-b$POS_A,pch=20,cex=0.02,col=colors[cut(b$R2,breaks=seq(0,1,length.out = 11),include.lowest = T)],xlim=c(from,to),ylim=c(from,to), ...)
}

# Load some LD data from Tomahawk
#ld<-read.delim(commandArgs(TRUE)[1],h=T,comment.char='#')

# Use `data.table` package for fast loads
library(data.table)
ld<-fread(commandArgs(TRUE)[1],skip="FLAG") # First line starts with the pattern "^FLAG"

pdf(commandArgs(TRUE)[2], height=8, width=8)
#par(mfrow=c(1,3))
par(pty="s")
plotLDRegion(ld[ld$R2>0.2,],min(ld$POS_A),max(ld$POS_B),main=commandArgs(TRUE)[1],TRUE)
abline(v=34520327+194021, lty=2, col="green")
abline(h=34520327+194021, lty=2, col="green")

monotigs <- read.table(commandArgs(TRUE)[3])
monotigs$V1 <- as.character( monotigs$V1 )
monotigs$V2 <- as.numeric( monotigs$V2 )
abline(v=monotigs$V2, lty=2, lwd=0.5)
abline(h=monotigs$V2, lty=2, lwd=0.5)
text(monotigs$V2+10000, monotigs$V2, monotigs$V1, adj=c(0, NA), cex=0.35)

dev.off()
