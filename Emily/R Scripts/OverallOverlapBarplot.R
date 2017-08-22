setwd("~/Downloads")
library(ggplot2)
stats <- read.csv("ATACseq_Basic_Stats.csv")
#stats$Tissue <- factor(stats$Tissue)

#if you don't like the floating bars, just add this
#   + scale_y_continuous(expand=c(0,0))


#by forebrain embryo, forebrain postnatal, etc
#stats<-stats[order(stats$Less.Specific, stats$Tissue),]
stats$ENCODE.ID <- factor(stats$ENCODE.ID, levels = stats$ENCODE.ID[order(stats$Less.Specific, stats$Tissue)])
stats$Tissue <- factor(stats$Tissue, c("forebrain embryo", "forebrain postnatal", "hindbrain embryo", "hindbrain postnatal", "midbrain embryo", "intestine embryo", "intestine postnatal", "kidney embryo", "liver embryo", "liver postnatal", "lung postnatal", "neural tube", "stomach postnatal"))
graph <-ggplot(stats, aes(x=stats$ENCODE.ID, y=stats$Percent.Overlap, fill=stats$Tissue)) + geom_bar(stat="identity") + labs(title="Percent Overlap Graph", x= "ENCODE ID", y="Percent of Overlap with cREs", fill="Tissue Type")
graph + theme(axis.text.x=element_text(angle=90, hjust=0, vjust=.5), plot.title=element_text(hjust=.5, face="bold")) #+ geom_text(aes(label=stats$Percentage), size = 3)  + ylim(.7,1)
pdf("Percent_Overlap_more.pdf")
graph 
dev.off()

#just by brain, intestine, etc
stats$ENCODE.ID <- factor(stats$ENCODE.ID, levels = stats$ENCODE.ID[order(stats$Less.Specific, stats$Tissue)])
graph <-ggplot(stats, aes(x=stats$ENCODE.ID, y=stats$Percent.Overlap, fill=stats$Less.Specific)) + geom_bar(stat="identity") + labs(title="Percent Overlap Graph", x= "ENCODE ID", y="Percent of Overlap with cREs", fill="Tissue Type")
graph + theme(axis.text.x=element_text(angle=90, hjust=0, vjust=.5), plot.title=element_text(hjust=.5, face="bold"))

ggplot(stats, aes(x=stats$ENCODE.ID, y=stats$Percent.Overlap, fill=stats$Less.Specific)) + 
  geom_bar(stat="identity") + 
  labs(title="Percent Overlap Graph", x= "ENCODE ID", y="Percent of Overlap with cREs", fill="Tissue Type") +
  theme(axis.text.x=element_text(angle=90, hjust=0, vjust=.5), plot.title=element_text(hjust=.5, face="bold"))

pdf("Percent_Overlap_less.pdf")
graph
dev.off()

#trying to make it look better with labels etc
stats$ENCODE.ID <- factor(stats$ENCODE.ID, levels = stats$ENCODE.ID[order(stats$Less.Specific, stats$Tissue)])
graph <-ggplot(stats, aes(x=stats$ENCODE.ID, y=stats$Percent.Overlap*100, fill=stats$Less.Specific)) + geom_bar(stat="identity") + labs(title="Percent Overlap Graph", x= "ENCODE ID", y="Percent of Overlap with cREs", fill="Tissue Type")
graph + theme(axis.text.x=element_text(angle=90, hjust=0, vjust=.5), plot.title=element_text(hjust=.5)) + geom_text(aes(label=stats$Percentage), size = 3, angle= 90, position=position_stack(vjust=1)) #+ coord_cartesian(ylim=c(0,1.0))
pdf("PercentOverlapWithLabels2")
dev.off()

ggplot(stats, aes(x=stats$ENCODE.ID, y=stats$Percent.Overlap*100, fill=stats$Less.Specific)) + 
  geom_bar(stat="identity") + 
  labs(title="Percent Overlap Graph", x= "ENCODE ID", y="Percent of Overlap with cREs", fill="Tissue Type") +
  theme(axis.text.x=element_text(angle=90, hjust=0, vjust=.5), plot.title=element_text(hjust=.5, face = "bold")) + 
  geom_text(aes(label=stats$Percentage), size = 3, angle= 90, position=position_stack(vjust=.90)) #+ coord_cartesian(ylim=c(0,1.0))

#stats$Less.Specific<- factor(stats$Less.Specific, levels=c("brain", "intestine", "kidney", "liver", "lung", "neural tube", "stomach"))
#stats <- stats[order(stats$Less.Specific),]
ggplot(stats, aes(x=stats$ENCODE.ID, y=stats$Percent.Overlap, fill=stats$Less.Specific)) + geom_bar(stat="identity")



