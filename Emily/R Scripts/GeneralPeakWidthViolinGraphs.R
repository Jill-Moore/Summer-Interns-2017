setwd("~/From Server/dataSplitforViolins/")
library(ggplot2)
library(reshape2)

#column is just the lengths
for (tissue in c("FacialProminence-e11.5", "FacialProminence-e14.5", "Forebrain-e14.5", "Hindbrain-e11.5", "Hindbrain-e14.5", "Limb-e11.5", "Limb-e14.5", "Liver-e14.5", "Lung-e14.5", "Midbrain-e11.5", "NeuralTube-e11.5")){
  #tissue="FacialProminence-e11.5"
  setwd("~/From Server/dataSplitforViolins/")
  a <- data.frame(read.csv(paste(tissue,"-A-with-D-LENGTHS.csv", sep=""), header=FALSE))
  a$V2 <- "ATAC-seq peaks that overlap DNase peaks"
  act <- nrow(a)
  b <- data.frame(read.csv(paste(tissue,"-A-wo-D-LENGTHS.csv", sep=""), header=FALSE))
  b$V2 <- "ATAC-seq peaks that do not overlap DNase peaks"
  bct <- nrow(b)
  c <- data.frame(read.csv(paste(tissue,"-D-with-A-LENGTHS.csv", sep=""), header=FALSE))
  c$V2 <- "DNase peaks that overlap ATAC-seq peaks"
  cct <- nrow(c)
  d <- data.frame(read.csv(paste(tissue,"-D-wo-A-LENGTHS.csv", sep=""), header=FALSE))
  d$V2 <- "DNase peaks that do not overlap ATAC-seq peaks"
  dct <- nrow(d)
  
  tot <- rbind(a,b,c,d)
  names(tot) <- c("Width", "Type")
  
  
ggplot(tot, aes(x=Type, y=Width, fill=Type)) +
    geom_violin(stat = "ydensity") +
    geom_boxplot(width=.15) +
    scale_y_log10() +
    labs(title="Widths of Peaks", y="Width", subtitle=paste("For", tissue)) +
    theme(plot.title=element_text(hjust=.5, face="bold"), axis.text.x=element_blank(), axis.title.x = element_blank(), axis.ticks.x =element_blank(), plot.subtitle = element_text(hjust=.5)) +
    annotate("text", label = act, x =2, y = 20, size = 4) + 
    annotate("text", label = bct, x =1, y = 20, size = 4) +
    annotate("text", label = cct, x =4, y = 20, size = 4) + 
    annotate("text", label = dct, x =3, y = 20, size = 4)
    
  #geom_text(aes(y = 50, x=2, label = as.integer(act)),vjust = 0, size = 6) +
  #  geom_text(aes(y = 50, x = 1, label = as.integer(bct)),vjust = 0, size = 6) +
  #  geom_text(aes(y = 50, x = 4,label = as.integer(cct)),vjust = 0, size = 6) +
  #  geom_text(aes(y = 50, x=3, label = as.integer(dct)),vjust = 0, size = 6)
  
setwd("~/CountsPeakWidthViolinGraphs")
  ggsave(paste(tissue, "-PeakWidths.png", sep=""), width=7, height=4, units='in')
}
