#!/usr/bin/env Rscript
args = commandArgs(trailingOnly = TRUE)

x <- NULL
y <- NULL
peak <- NULL
color <- "blue"
size <- 0.5
title <- NULL
corr <- NULL
cell <- NULL

if(length(args) == 0) {
  print("Tool:    signals-over-peak")
  print("Summary: create scatterplot of the average signals over each peak")
  print("Usage:   Rscript signals-over-peak.R avg-signal-1 avg-signal-2 peak [cell]")
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

