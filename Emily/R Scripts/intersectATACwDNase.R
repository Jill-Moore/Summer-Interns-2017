setwd("~/")
input1 <- read.csv("ATACwithDNase.csv", header = TRUE)
input2 <- read.csv("DNasewithATAC.csv", header = TRUE)

input1$Type <- "ATAC-seq\nintersected\nwith DNase"
input2$Type <- "DNase intersected\nwith ATAC-seq"

#together
g <- data.frame(input1$Tissue_Timepoint, input1$Means, input1$Type)
h <- data.frame(input2$Tissue_Timepoint, input2$Means, input2$Type)

names(g) <- c("Bin", "Mean", "Type")
names(h) <- c("Bin", "Mean", "Type")

library(reshape2)
tot <- rbind(g,h)

library(ggplot2)

ggplot(tot, aes(x=Bin, y=Mean*100, col=Type)) + geom_point() +
  labs(title="Mean Percent Overlap with ATAC-seq intersected with DNase and vice versa", y="% Overlap") +
  #geom_text(aes(label = title, hjust=.5)) +
  coord_cartesian(ylim=c(0,100)) +
  theme(legend.title = element_blank(), legend.text = element_text(size=6), plot.title=element_text(face="bold", hjust=.3))

#pdf("intersectATACwDNase.pdf")
#dev.off()
#png("intersectATACwDNase.png", width=10, height=3, units='cm', res=300)

#All the ones separately

#ATAC-seq
ggplot(input1, aes( x= Tissue_Timepoint, y=FacialProminence.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "FacialProminence.e11.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=FacialProminence.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "FacialProminence.e14.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=Forebrain.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Forebrain.e14.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=Hindbrain.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Hindbrain.e11.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=Hindbrain.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Hindbrain.e14.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=Limb.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Limb.e11.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=Limb.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Limb.e14.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=Liver.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Liver.e14.5", x="ATAC-seq Bins")
# ^ Liver might look so dramatic because there are less than 65000 DNase peaks
ggplot(input1, aes( x= Tissue_Timepoint, y=Lung.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Lung.e14.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=Midbrain.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Midbrain.e11.5", x="ATAC-seq Bins")
#ggplot(input1, aes( x= Tissue_Timepoint, y=Midbrain.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "Midbrain.e14.5", x="ATAC-seq Bins")
ggplot(input1, aes( x= Tissue_Timepoint, y=NeuralTube.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with DNase Peaks", title = "NeuralTube.e11.5", x="ATAC-seq Bins")

#DNase
ggplot(input2, aes( x= Tissue_Timepoint, y=FacialProminence.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "FacialProminence.e11.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=FacialProminence.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "FacialProminence.e14.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=Forebrain.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Forebrain.e14.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=Hindbrain.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Hindbrain.e11.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=Hindbrain.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Hindbrain.e14.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=Limb.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Limb.e11.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=Limb.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Limb.e14.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=Liver.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Liver.e14.5", x="DNase Bins")
# ^ After 65000 Liver is all the same because there are less than 65000 peaks 
ggplot(input2, aes( x= Tissue_Timepoint, y=Lung.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Lung.e14.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=Midbrain.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Midbrain.e11.5", x="DNase Bins")
#ggplot(input2, aes( x= Tissue_Timepoint, y=Midbrain.e14.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "Midbrain.e14.5", x="DNase Bins")
ggplot(input2, aes( x= Tissue_Timepoint, y=NeuralTube.e11.5 * 100)) + geom_point() + coord_cartesian(ylim=c(0,100)) + labs(y="% Overlap with ATAC-seq Peaks", title = "NeuralTube.e11.5", x="DNase Bins")

