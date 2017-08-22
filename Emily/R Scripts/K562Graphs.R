setwd("~/Files for Graphs/")
library(ggplot2)
library(reshape2)

#columns in data are bin, enhancer, promoter, CTCF, DNase
bern <- data.frame(read.csv(header=TRUE, "Bernstein.csv"))
mbern <- melt(bern, id.vars="Bin")

farn <- data.frame(read.csv(header=TRUE, "Farnham.csv"))
mfarn <- melt(farn, id.vars="Bin")

setwd("~/")
ggplot(mbern, aes(x=Bin, y=value, color=variable)) + 
  geom_line() + geom_point() +
  labs(title="Bernstein K562", y="Number") +
  theme(plot.title=element_text(hjust=.5, face="bold"), legend.title = element_blank())
ggsave("Bernstein_K562.png", width=7, height=4, units='in')


ggplot(mfarn, aes(x=Bin, y=value, color=variable)) + 
  geom_line() + geom_point() +
  labs(title="Farnham K562", y="Number") +
  theme(plot.title=element_text(hjust=.5, face="bold"), legend.title = element_blank())
ggsave("Farnham_K562.png", width=7, height=4, units='in')
