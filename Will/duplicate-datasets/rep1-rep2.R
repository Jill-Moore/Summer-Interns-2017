# Author: Will Zhang

library(ggplot2)

### Variables ###
file <- "../gin/heart.gingeras.dat"
col <- "red"
lim <- c(0,6)
title <- "Comparison of Heart TPM (Gingeras)"


data <- read.table(file, header = TRUE)
p <- ggplot(data, aes(x = log10(data$rep1+1), y = log10(data$rep2+1)))
p + geom_point(color = col, size = 0.5) + scale_x_continuous(limits = lim) + scale_y_continuous(limits = lim) + coord_fixed() + ggtitle(title) + xlab("rep1 log10(TPM)") + ylab("rep2 log10(TPM)") + theme(plot.title = element_text(face = "bold", color = "#323232", hjust = 0.5, size = 18), axis.title = element_text(face = "bold"))
