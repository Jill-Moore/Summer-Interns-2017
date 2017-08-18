#!/usr/bin/env Rscript
args = commandArgs(trailingOnly = TRUE)

library(ggplot2)

x <- NULL
y <- NULL
peak <- NULL
color <- "blue"
size <- 0.5
title <- NULL
corr <- NULL
cell <- NULL

if(length(args) == 0) {
  cat("Tool:    signals-over-peak")
  cat("Summary: create scatterplot of the average signals over each peak and output correlation in STDOUT.")
  cat("Usage:   Rscript signals-over-peak.R avg-signal-1 avg-signal-2 peak [cell]")
  stop("Incorrect number of arguments.")
} else if (length(args) == 3) {
  x <- args[1]
  y <- args[2]
  peak <- args[3]
  title <- paste("Average Signal across", peak)
} else if (length(args) == 4) {
  x <- args[1]
  y <- args[2]
  peak <- args[3]
  cell <- args[4]
  title <- paste("Average Signal across", peak, "in", cell)
} else {
  stop("Incorrect number of arguments.")
}

xtable <- read.table(x)
ytable <- read.table(y)
data <- data.frame(xaxis = xtable$V5, yaxis = ytable$V5)
corr <- cor(data$xaxis, data$yaxis)

cat(round(corr, digits=3))

p <- ggplot(data, aes(x = xaxis, y = yaxis)) + 
  geom_point(color = color) + 
  ggtitle(title) + 
  xlab(paste(x, "Signal")) + 
  ylab(paste(y, "Signal")) + 
  theme(plot.title = element_text(face = "bold", color = "#323232", hjust = 0.5), 
        axis.title = element_text(face = "bold", color = "#323232"))
ggsave(paste(x,"-",y,".png", sep = ""))