# Author: Shaimae Elhajjajy

# Load ggplot2 package
library(ggplot2)

# Read in the data
GM12878_D2 <- read.csv("GM12878-D2.csv", header = TRUE)

# Isolate the TFs
all_TFs <- GM12878_D2$X.1[-c(1,1)]
# Isolate the fraction of overlaps
all_Overlaps <- GM12878_D2$X.3[-c(1,1)]
# Isolate the log2(ratios)
all_Ratios <- GM12878_D2$X.5[-c(1,1)]

# Find the top 10 peak overlaps
Fraction_Overlap <- head(rev(sort(all_Overlaps)), 10)

# Find the corresponding TFs and log2(ratios) to the top 10 peak overlaps
for(i in 1:10) { 
  all_TFs[i] <- all_TFs[which(all_Overlaps == Fraction_Overlap[i])]
  all_Ratios[i] <- all_Ratios[which(all_Overlaps == Fraction_Overlap[i])]
}

# Isolate the top 10 TFs
TFs <- head(all_TFs, 10)
# Isolate the ratios that correspond to the top 10 TFs
Ratios <- head(all_Ratios, 10)


TFs <- as.character(TFs)
Fraction_Overlap <- as.numeric(as.character(Fraction_Overlap))
Ratios <- as.numeric(as.character(Ratios))

# Create a data frame
GM12878_D2 <- data.frame(TFs, Fraction_Overlap, Ratios, stringsAsFactors = FALSE)

# View the data frame
GM12878_D2

# Set the palette (appropriate colors)
P_palette <- c("gray60", "white", "#06DA93")

# Set the theme
theme_set(theme_classic())

# Initialize the plot (set x and y variables)
g <- ggplot(GM12878_D2, aes(x = TFs, y = Fraction_Overlap))

# Initialize the file
pdf("GM12878-DNase-Group2.pdf")

# Plot
g + geom_bar(stat = "identity",  width = 0.75, aes(fill = GM12878_D2$Ratios),
             color = "black",
             size = 0.3) + 
  labs(title = "GM12878 DNase Group 2",
       subtitle = "Top 10 TFs",
       caption = "*Ratio = percent overlap (DNase Group 2) : percent overlap (aggreagate of other categories)",
       x = "Transcription Factors",
       y = "Percent of Peak Overlap") + 
  theme(plot.title = element_text(size = 20,
                                  face = "bold", 
                                  hjust = 0.5, 
                                  color = "grey30"), 
        plot.subtitle = element_text(size = 14,
                                     hjust = 0.5,
                                     color = "grey30"),
        plot.caption = element_text(size = 8,
                                    hjust = 0.5),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14), 
        axis.text.x = element_text(size = 10, 
                                   angle = 20, 
                                   vjust = 0.75,
                                   color = "black"),
        axis.text.y = element_text(size = 10,
                                   color = "black"),
        legend.title = element_text(size = 12),
        legend.title.align = 0.5,
        legend.text = element_text(size = 10)) + 
  scale_x_discrete(limits = TFs) + # Stop x-axis from being alphabetically sorted
  scale_fill_gradientn(colors = P_palette, guide = "colorbar",
                       limits = c(-1.5, 1.5), name = "log2(Ratio*)") +
  coord_cartesian(ylim=c(0, 1)) # + # Set y-axis scale
  # geom_text(aes(label = Fraction_Overlap), vjust = -0.5, size = 2)

dev.off()

