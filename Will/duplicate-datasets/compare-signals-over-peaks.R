library(ggplot2)

### Variables ###
b <- "hg19/results/hg19-bernstein.sk-n-sh.results.dat"
f <- "hg19/results/hg19-farnham.sk-n-sh.results.dat"
title <- "Average Signal Across hg19 cREs in SK-N-SH cells"
lim <- c(0,40)
col <- "orange"

bern <- read.table(b)
far <- read.table(f)
data <- data.frame(x = bern$V5, y = far$V5)
r <- cor(data$x, data$y)

p <- ggplot(data, aes(x = x, y = y))
p + geom_point(color = col, size = 0.5) + coord_fixed() + scale_x_continuous(limits = lim) + scale_y_continuous(limits = lim) + ggtitle(title) + xlab("Bernstein Signal") + ylab("Farnham Signal") + theme(plot.title = element_text(face = "bold", color = "#323232", hjust = 0.5), axis.title = element_text(face = "bold", color = "#323232")) + annotate(geom = "label", x = 25, y = 25, label = paste("R = ", round(r, digits = 4)))
                                                                                                                                                                                                                                                                                                                                                         
