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


# annotations relevant to the diatom analysis
#abline(v=36843744+194021, lty=2, col="green")
#abline(h=36843744+194021, lty=2, col="green")

# take the monotigs
monotigs <- read.table(commandArgs(TRUE)[5])
monotigs$V1 <- as.character( monotigs$V1 )
monotigs$V2 <- as.numeric( monotigs$V2 )

mrgenes <- read.delim(commandArgs(TRUE)[6])

ggplot(d, aes(x=x, y=y, fill=value)) +
geom_tile() +
coord_fixed() +
theme_bw() +
scale_fill_gradientn(colors=myPalette(100),name="mean R2") +
annotate("text", x=mrgenes$start.trans+(pos_length/150), y=mrgenes$start.trans+(pos_length/150), label=mrgenes$query, angle=-45, size=1) +
geom_vline(xintercept=mrgenes$start.trans, color="black", linetype="dashed", size=0.1) +
geom_hline(yintercept=mrgenes$start.trans, color="black", linetype="dashed", size=0.1) +
xlim(start_pos, end_pos) +
ylim(start_pos, end_pos)


ggsave(plotname, height=12, width=13.5)

# for showing where the tigs are
#annotate("text", x=monotigs$V2+(pos_length/25), y=monotigs$V2+(pos_length/150), label=monotigs$V1, angle=0, size=1) +
#geom_vline(xintercept=36843744+194021, color="green", linetype="dashed") +
#geom_hline(yintercept=36843744+194021, color="green", linetype="dashed") +
#geom_vline(xintercept=monotigs$V2, linetype="dotted", size=0.25) +
#geom_hline(yintercept=monotigs$V2, linetype="dotted", size=0.25) +
