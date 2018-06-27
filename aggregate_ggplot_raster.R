#!/usr/bin/env Rscript

require(ggplot2)

infile <- commandArgs(TRUE)[1]
plotname <- commandArgs(TRUE)[2]
start_pos <- as.numeric(commandArgs(TRUE)[3])
end_pos <- as.numeric(commandArgs(TRUE)[4])
pos_length <- end_pos - start_pos
d <- read.delim(infile, header=F)
d <- data.frame(value=unlist(d), x=rep(1:dim(d)[1], each=dim(d)[1]), y=1:dim(d)[2])
d$x <- d$x / max(d$x)
d$y <- d$y / max(d$y)
d$x <- (d$x * pos_length) + start_pos
d$y <- (d$y * pos_length) + start_pos
colors <- c("white", "blue", "blue", "blue", "blue", "blue", "red")
myPalette <- colorRampPalette(colors)
d <- subset(d, y>x) # make upper triangular
#value.quantiles <- quantile(d$value,seq(0,1,0.01))
#ggplot(d, aes(x=x, y=y, fill=.bincode(value,value.quantiles,include.lowest=TRUE))) + geom_tile() + coord_fixed() + theme_bw() + scale_fill_gradientn(colors=myPalette(length(value.quantiles)),name="mean R2 bin")
ggplot(d, aes(x=x, y=y, fill=value)) + geom_tile() + coord_fixed() + theme_bw() + scale_fill_gradientn(colors=myPalette(100),name="mean R2")
ggsave(plotname, height=8, width=9)
