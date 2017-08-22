#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)

library(ggplot2)

table<-NULL

if(length(args) == 0) {
  cat("Tool:    top-overlap")
  cat("Summary: create bargraph of the % overlap of the top (by count) histone mark/TF.")
  cat("Usage:   Rscript top-overlap.R table")
  stop("Incorrect number of arguments.")
} else if(length(args) == 1) {
  table<-read.table(args[1])
} else {
  stop("Incorrect number of arguments.")
}

