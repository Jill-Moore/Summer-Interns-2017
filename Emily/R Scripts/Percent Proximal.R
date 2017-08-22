temp<-read.csv("~/Files for Graphs/compareWithDNase.csv", header=TRUE)

setwd("~/")
library(ggplot2)
temp<-read.csv("~/Files for Graphs/compareWithDNaseForBar.csv", header=TRUE)
cols=c("#FD8283", "#25D995")

ggplot(temp, aes(x=temp$X, y=temp$X..Proximal*100, fill=temp$Type)) + geom_bar(stat="identity", position=position_dodge()) +
  labs(title="Percent Proximal", x="Tissue-Timepoint", y="% Proximal") +
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=.5), plot.title=element_text(hjust=.5, face = "bold")) +
  guides(fill=guide_legend(title=NULL)) + scale_y_continuous(limit = c(0, 100)) + scale_fill_manual(values=cols)
png("PercentProx.png", width = 7, height = 4, units='in', res=300)
#pdf("PercentProx.pdf")
dev.off()

#START HERE FOR SCATTERPLOT
df <- data.frame(read.csv("proximityATAC.csv", header=TRUE))
rotDf<- data.frame(read.csv("rotatedProximityATAC.csv", header = TRUE))
rotDNase <- read.csv("rotatedProximityDNase.csv", header = TRUE)

#get both on same thing
rotDf$Type <- "ATAC-seq"
rotDNase$Type <- "DNase"

g <- data.frame(rotDf$ATAC.seq, rotDf$Means, rotDf$Type)
h <- data.frame(rotDNase$DNase, rotDNase$Means, rotDNase$Type)

names(g) <- c("Bin", "Mean", "Type")
names(h) <- c("Bin", "Mean", "Type")

library(reshape2)
tot <- rbind(g,h)

ggplot(tot, aes(x=Bin, y=Mean*100, col=Type)) + geom_point() +
  labs(title="Average Percent Proximal of Ranked Bins", y="% Proximal") +
  theme(plot.title=element_text(face= "bold", hjust=.5)) +
  coord_cartesian(ylim=c(0,100))

pdf("PercentProximalRanked.pdf")
dev.off()



#ONE WITH THE MEANS FOR ATAC-SEQ
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$Means)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ATAC-seq Means", x="Bins")# + geom_line()

#THE MEANS OF DNASE
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$Means)) + geom_point()  + coord_cartesian(ylim=c(0, 1))+ labs(y="% Proximal", title="DNase Means", x="Bins")

#all the ATAC-seq ones graphed separately
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF705JZG)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF705JZG", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF786CPM)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF786CPM", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF785JAD)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF785JAD", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF281XXQ)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF281XXQ", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF170QFR)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF170QFR", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF098TCT)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF098TCT", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF379WSA)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF379WSA", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF305TSN)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF305TSN", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF280EKN)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF280EKN", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF095GZW)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF095GZW", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF759RYM)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF759RYM", x="Bins")
ggplot(rotDf, aes(x=rotDf$ATAC.seq, y=rotDf$ENCFF808NFI)) + geom_point() + coord_cartesian(ylim=c(.3, 1)) + labs(y="% Proximal", title="ENCFF808NFI", x="Bins")


#All the DNase ones graphed separately
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF775ETC)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF775ETC", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF113IAK)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF113IAK", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF380PSC)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF380PSC", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF150NWR)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF150NWR", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF600NOU)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF600NOU", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF537JUQ)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF537JUQ", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF769OSQ)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF769OSQ", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF149WTF)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF149WTF", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF116LVY)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF116LVY", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF691KFW)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF691KFW", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF538GHV)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF538GHV", x="Bins")
ggplot(rotDNase, aes(x=rotDNase$DNase, y=rotDNase$ENCFF882TYQ)) + geom_point() + coord_cartesian(ylim=c(0, 1)) + labs(y="% Proximal", title="ENCFF882TYQ", x="Bins")



