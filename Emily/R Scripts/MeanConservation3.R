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
  scale_fill_hue(c=90, l=70)# +scale_fill_manual(values=cols)

png("MeanConservation2.png", width =7, height =4, units='in', res = 300)

#pdf("MeanConservation1.pdf")
dev.off()

#exonOverlap
ggplot(chart, aes(x=chart$File, y=chart$Overlap.with.Exons*100,  fill=chart$Type)) +
  geom_bar(stat="identity", position=position_dodge()) +
  labs(x="Tissue", y="Overlap with Exons (%)", title="Overlap with Exons based on Category") +
  guides(fill=guide_legend(title="Category")) + 
  theme(axis.text.x=element_text(angle=90, hjust=1, vjust=.5, size = 8), plot.title=element_text(face="bold", hjust=.5))  +
  scale_fill_hue(c=90, l=70)# +scale_fill_manual(values=cols)

png("OverlapwithExons.png", width =7, height =4, units='in', res = 300)

library(RColorBrewer)
display.brewer.all()
cols=c("#E41A1C", "#BD0026", "#006D2C", "#08519C")
brewer.pal(3, "Set1")
brewer.pal(5, "YlOrRd")
brewer.pal(6, "Greens")
brewer.pal(5, "Blues")
