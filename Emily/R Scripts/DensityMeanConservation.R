setwd("~/Files for Graphs/")
library(ggplot2)
chart <- data.frame(read.csv("25000MidbrainForDensity.csv", header = FALSE))

names(chart) <- c("Mean Conservation", "Type")

#chart$`Mean Conservation` <- chart$`Mean Conservation`*100
chart$Type <- gsub("ATAC", "Overlap with ATAC-seq\n(331 Peaks)", chart$Type)
chart$Type <- gsub("NO", "Do not Overlap with \nATAC-seq (281 Peaks)", chart$Type)

#better with just the lines
ggplot(chart, aes(x=chart$`Mean Conservation`, col=chart$Type)) + 
  geom_density() +
  labs(x="Mean Conservation", y="Density", title="Mean Conservation for DNase Peaks", subtitle="Distal Peaks from Midbrain-e11.5 data") +
  guides(color=guide_legend(title="Category")) +
  theme(plot.title=element_text(hjust = .5, face="bold"), plot.subtitle = element_text(hjust=.5)) +
  theme(legend.text = element_text(size=8))

#50000
d <- data.frame(read.csv("50000distalMidbrainForDensity", header = FALSE))
names(d) <- c("Mean Conservation", "Type")
d$Type <- gsub("ATAC", "Overlap with ATAC-seq\n(1620 Peaks)", d$Type)
d$Type <- gsub("NO", "No overlap with\nATAC-seq (3467 Peaks)", d$Type)

ggplot(d, aes(x=d$`Mean Conservation`, col=d$Type)) + 
  geom_density() +
  labs(x="Mean Conservation", y="Density", title="Mean Conservation for DNase Peaks", subtitle="Distal Peaks from Midbrain-e11.5 data") +
  guides(color=guide_legend(title="Category")) +
  theme(plot.title=element_text(hjust = .5, face="bold"), plot.subtitle = element_text(hjust=.5)) +
  theme(legend.text = element_text(size=8))

#png("50000MidbrainDensityConservation.png", width=7, height=4, units='in', res = 300)
#dev.off()

edited <- data.frame(read.csv("edit25000MidbrainForDensity.csv", header = FALSE))
names(edited) <- c("Mean Conservation", "Type")
edited$`Mean Conservation` <- gsub("%", "", edited$`Mean Conservation`)

edited$Type <- gsub("ATAC", "Overlap with ATAC-seq (331 Peaks)", edited$Type)
edited$type <- gsub("NO", "Do not Overlap with ATAC-seq (281 Peaks)", edited$Type)
edited$`Mean Conservation` <- (as.numeric(edited$`Mean Conservation`))*100

ggplot(edited, aes(x=chart$`Mean Conservation`, col=chart$Type)) + 
  geom_density() +
  labs(x="Mean Conservation (%)", y="Density", title="Mean Conservation for DNase Peaks", subtitle="Distal Peaks from Midbrain-e11.5 data") +
  guides(color=guide_legend(title="Category")) +
  theme(plot.title=element_text(hjust = .5, face="bold"), plot.subtitle = element_text(hjust=.5)) +
  theme(legend.text = element_text(size=8))

#filled in and weird
ggplot(chart, aes(x=chart$`Mean Conservation`, fill=chart$Type)) + 
  geom_density(position="stack", alpha = .6) +
  labs(x="Mean Conservation (%)", y="Density", title="Mean Conservation for DNase Peaks", subtitle="Midbrain-e11.5 data") +
  guides(fill=guide_legend(title="Category")) +
  theme(plot.title=element_text(hjust = .5, face="bold"), plot.subtitle = element_text(hjust=.5))

png("DensityConservation.png", width=7, height=4, units='in', res = 300)
dev.off()
