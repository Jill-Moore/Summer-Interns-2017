library(ggplot2)

d <- read.table("", header = TRUE)
log10d <- data.frame(rep1=log10(d$rep1 + 1), rep2=log10(d$rep2 + 1))
p <- ggplot(data=log10d, aes(x=rep1, y=rep2))
p + geom_point(color="blue", size=0.5) + xlab("log10(TPM) rep1") + ylab("log10(TPM) rep2") + ggtitle("Comparison of Heart TPM (Gingeras)") + theme(plot.title = element_text(face="bold", hjust=0.5, size=28, color="323232"), axis.title = element_text(face="bold", color="#323232"))