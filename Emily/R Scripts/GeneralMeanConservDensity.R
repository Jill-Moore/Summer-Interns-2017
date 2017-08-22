#Density plot of Mean Conservation for any of the tissues
#General script
#make sure you make the folder that the info will go into though

folder <- "~/MeanConservationGraphsNew"
dir.create(folder)

library(ggplot2)

for (tissue in c("FacialProminence-e11.5", "FacialProminence-e14.5", "Forebrain-e14.5", "Hindbrain-e11.5", "Hindbrain-e14.5", "Limb-e11.5", "Limb-e14.5", "Liver-e14.5", "Lung-e14.5", "Midbrain-e11.5", "NeuralTube-e11.5")){
#tissue <- "NeuralTube-e11.5"

setwd("~/Files for Graphs/dataConservation/")
first <- paste(tissue, "-distalATAC-conserv", sep="")
second <- paste(tissue, "-distalNO-conserv", sep="")

a <- data.frame(read.delim(first, header=FALSE))
a$Type <- paste(paste("Overlap with ATAC-seq (", nrow(a), sep=""), " peaks)", sep="")
b <- data.frame(read.delim(second, header=FALSE))
b$Type <- paste(paste("No overlap with ATAC-seq (", nrow(b), sep=""), " peaks)", sep="")



library(reshape2)
wilcox.test(a$V5, b$V5)
p <- format.pval(wilcox.test(a$V5, b$V5)$p.value, digits=5)
#here <- paste("P value:", p)
library(grid)
grob <- grobTree(textGrob(paste("P value:", p), x=.95, y=.95, hjust=1, vjust=1,
                          gp=gpar(col="black", fontsize=8)))


c <- rbind(a, b)

ggplot(c, aes(x=V5, col=Type)) +
  geom_density() +
  labs(x="Mean Conservation", y="Density", title="Mean Conservation for DNase Peaks", subtitle=paste("Distal Peaks from", tissue)) +
  guides(color=guide_legend(title="Category")) +
  theme(plot.title=element_text(hjust = .5, face="bold"), plot.subtitle = element_text(hjust=.5)) +
  theme(legend.text = element_text(size=8)) +
  annotation_custom(grob)

setwd(folder)
#png(paste(tissue, "MeanConservDensity.png", sep=""), width = 7, height = 5, units='in', res = 300)
ggplot(c, aes(x=V5, col=Type)) +
  geom_density() +
  labs(x="Mean Conservation", y="Density", title="Mean Conservation for DNase Peaks", subtitle=paste("Distal Peaks from", tissue)) +
  guides(color=guide_legend(title=NULL)) +
  theme(plot.title=element_text(hjust = .5, face="bold"), plot.subtitle = element_text(hjust=.5)) +
  theme(legend.text = element_text(size=8)) +
  annotation_custom(grob)

ggsave(paste(tissue, "MeanConservDensity.png", sep=""), width=7, height=4, units='in')
#invisible(readline(prompt="Press [enter] to continue"))
#dev.off()
}


