setwd("~/Downloads")
library(ggplot2)
chart <- data.frame(read.csv("meanConservation and exonOverlap.csv", header = TRUE))

chart$File <- gsub("-distalATAC||-distalNO||-proximalATAC||-proximalNO", "", chart$File)

#meanConservation first
ggplot(chart, aes(x=chart$File, y=chart$Mean.Conservation*100,  fill=chart$Type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x="Tissue", y="Mean Conservation (%)", title="Mean Conservation Chart based on Category") +
  guides(fill=guide_legend(title="Category")) + 
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=.5, size = 8), plot.title=element_text(face="bold", hjust=.5)) + 
  scale_fill_hue(c=90, l=70) +# +scale_fill_manual(values=cols)
  theme(legend.text=element_text(size=6)) 
  
png("MeanConservation.png", width =7, height =4, units='in', res = 300)

#pdf("MeanConservation1.pdf")
dev.off()

#exonOverlap
ggplot(chart, aes(x=chart$File, y=chart$Overlap.with.Exons*100,  fill=chart$Type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x="Tissue", y="Overlap with Exons (%)", title="Overlap with Exons based on Category") +
  guides(fill=guide_legend(title="Category")) + 
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=.5, size = 8), plot.title=element_text(face="bold", hjust=.5))  +
  scale_fill_hue(c=90, l=70) +# +scale_fill_manual(values=cols) 
  theme(legend.text=element_text(size=6))

png("OverlapwithExons.png", width =7, height =4, units='in', res = 300)


#Number of peaks
ggplot(chart, aes(x=chart$File, y=chart$X..of.DNase.Peaks/250,  fill=chart$Type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x="Tissue", y="% of Peaks in Each Category", title="Percent of the top 25000 Peaks in each Category") +
  guides(fill=guide_legend(title="Category")) + 
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=.5, size = 8), plot.title=element_text(face="bold", hjust=.5))  +
  scale_fill_hue(c=90, l=70) +# +scale_fill_manual(values=cols)
  theme(legend.text=element_text(size=6)) +
  coord_cartesian(ylim=c(0, 100))

#50000 number of peaks
setwd("~/Files for Graphs/")
d <- data.frame(read.csv("50000splitSummary.csv", header = TRUE))
setwd("~/")
d$File <- gsub("-distalATAC||-distalNO||-proximalATAC||-proximalNO", "", d$File)

ggplot(d, aes(x=d$File, y=d$X..of.DNase.Peaks/500,  fill=d$Type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x="Tissue", y="% of Peaks in Each Category", title="Percent of the top 50000 Peaks in each Category") +
  guides(fill=guide_legend(title="Category")) + 
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=.5, size = 8), plot.title=element_text(face="bold", hjust=.5))  +
  scale_fill_hue(c=90, l=70) +# +scale_fill_manual(values=cols)
  theme(legend.text=element_text(size=6)) +
  coord_cartesian(ylim=c(0, 100))

png("50000PercentCategory.png", width=7, height =4, units = 'in', res = 300)
dev.off()

#Number instead of Percent
ggplot(chart, aes(x=chart$File, y=chart$X..of.DNase.Peaks,  fill=chart$Type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x="Tissue", y="# of Peaks in Each Category", title="Number of the top 25000 Peaks in each Category") +
  guides(fill=guide_legend(title="Category")) + 
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=.5, size = 8), plot.title=element_text(face="bold", hjust=.5))  +
  scale_fill_hue(c=90, l=70) +# +scale_fill_manual(values=cols)
  theme(legend.text=element_text(size=6)) +
  coord_cartesian(ylim=c(0, 25000))
#png("25000NumberCategory.png", width=7, height =4, units = 'in', res = 300)


ggplot(d, aes(x=d$File, y=d$X..of.DNase.Peaks,  fill=d$Type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x="Tissue", y="# of Peaks in Each Category", title="Number of the top 50000 Peaks in each Category") +
  guides(fill=guide_legend(title="Category")) + 
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=.5, size = 8), plot.title=element_text(face="bold", hjust=.5))  +
  scale_fill_hue(c=90, l=70) +# +scale_fill_manual(values=cols)
  theme(legend.text=element_text(size=6)) +
  coord_cartesian(ylim=c(0, 50000))

#png("50000NumberCategory.png", width=7, height =4, units = 'in', res = 300)
dev.off()




png("PercentCategory.png", width=7, height =4, units = 'in', res = 300)
png("NumberCategory.png", width=7, height =4, units = 'in', res = 300)
library(RColorBrewer)
display.brewer.all()
cols=c("#E41A1C", "#BD0026", "#006D2C", "#08519C")
brewer.pal(3, "Set1")
brewer.pal(5, "YlOrRd")
brewer.pal(6, "Greens")
brewer.pal(5, "Blues")
