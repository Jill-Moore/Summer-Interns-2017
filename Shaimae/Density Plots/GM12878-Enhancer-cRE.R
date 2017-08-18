# Author: Shaimae Elhajjajy

GM12878_E_overlap <- read.table("cRE_GM12878+E.txt")
#GM12878_E_overlap <- data.matrix(GM12878_E_overlap)

GM12878_E_noOverlap <- read.table("cRE_GM12878-E.txt")
#GM12878_E_noOverlap <- data.matrix(GM12878_E_noOverlap)

library(ggplot2)

theme_set(theme_bw())

pdf("~/Desktop/Density plots/GM12878-Enhancer+-POL2-cRE.pdf")

ggplot(GM12878_E_overlap, aes(x=log(V1, 10))) + geom_density(color = "blue2") + 
  geom_density(data = GM12878_E_noOverlap, aes(x=log(V1, 10)), color = "tomato") + 
  labs(title = "GM12878 Enhancer-like",
       subtitle = "Length of cREs",
       caption = "The two groups, +POL2 and -POL2, are Enhancer-like cREs that overlap and don't overlap with POL2 peaks, respectively",
       x = "log10(Length)",
       y = "Density") + 
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
                                   color = "black"),
        axis.text.y = element_text(size = 10,
                                   color = "black"))

library(grid)

my_text1 <- "+POL2"
my_text2 <- "-POL2"
my_grob1 <- grid.text(my_text1, x = 0.62, y = 0.75, 
                      gp = gpar(col = "blue2", fontsize = 12))
my_grob2 <- grid.text(my_text2, x = 0.375, y = 0.75,
                      gp = gpar(col = "tomato", fontsize = 12))

dev.off()