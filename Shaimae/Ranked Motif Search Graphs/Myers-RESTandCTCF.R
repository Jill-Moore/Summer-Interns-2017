# Author: Shaimae Elhajjajy

# Import data from file
data <- read.table("~/Desktop/REST analysis/Top 10000 Peaks Graphs/K562-Myersdata.txt")

# Set variables
peaks <- c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 
           7000, 7500, 8000, 8500, 9000, 9500, 10000)
percentsREST <- data$V2
percentsCTCF <- data$V3

# Load ggplot2 package
library(ggplot2)

# Set the theme
theme_set(theme_bw())

# Initialize image
pdf("~/Desktop/REST analysis/Top 10000 Peaks Graphs/K562-Myers-REST-CTCF.pdf")

ggplot(data, aes(x=peaks)) + 
  geom_point(aes(y=percentsREST, color = "dodgerblue")) + 
  geom_point(aes(y=percentsCTCF, color = "chocolate1")) +
  geom_line(y=percentsREST, color = "dodgerblue3") +
  geom_line(y=percentsCTCF,color = "chocolate3") +
  labs(title = "K562 (Myers)",
       subtitle = "Percent of REST ChIP-seq peaks containing the REST and CTCF motifs",
       caption = "Analysis performed using FIMO test, with motifs REST@M6269_1.01 and CTCF@M4313_1.01; Bins = 500 peaks",
       x = "Peak Rank",
       y = "Percent of Peaks") + 
  theme(plot.title = element_text(size = 20,
                                  face = "bold",
                                  hjust = 0.5,
                                  color = "grey30"),
        plot.subtitle = element_text(size = 12,
                                     hjust = 0.5,
                                     color = "grey30"),
        plot.caption = element_text(size = 8,
                                    hjust = 0.5),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14), 
        axis.text.x = element_text(size = 10,
                                   vjust = 0.75,
                                   color = "black"),
        axis.text.y = element_text(size = 10,
                                   color = "black")) + 
  coord_cartesian(xlim = c(0, 10000), ylim = c(0, 100)) +
  scale_x_continuous(breaks = c(0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000,
                                9000, 10000)) + 
  scale_y_continuous(breaks = c(0,10,20,30,40,50,60,70,80,90,100)) +
  scale_color_manual(name="Motif", labels = c("CTCF", "REST"), 
                     values = c("chocolate1", "dodgerblue"))

dev.off()
