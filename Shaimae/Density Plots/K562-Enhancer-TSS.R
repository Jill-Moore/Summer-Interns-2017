# Author: Shaimae Elhajjajy

K562_E_overlap <- read.table("TSS_K562+E.txt")
#K562_E_overlap <- data.matrix(K562_E_overlap)

K562_E_noOverlap <- read.table("TSS_K562-E.txt")
#K562_E_noOverlap <- data.matrix(K562_E_noOverlap)

library(ggplot2)

theme_set(theme_bw())

pdf("~/Desktop/Density plots/K562-Enhancer+-POL2-TSS.pdf")

ggplot(K562_E_overlap, aes(x=log(V1, 10))) + geom_density(color = "blue2") + 
  geom_density(data = K562_E_noOverlap, aes(x=log(V1, 10)), color = "tomato") + 
  labs(title = "K562 Enhancer-like",
       subtitle = "Distance to TSS",
       caption = "The two groups, +POL2 and -POL2, are Enhancer-like cREs that overlap and don't overlap with POL2 peaks, respectively",
       x = "log10(Distance)",
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
my_grob1 <- grid.text(my_text1, x = 0.56, y = 0.825, 
                      gp = gpar(col = "blue2", fontsize = 12))
my_grob2 <- grid.text(my_text2, x = 0.775, y = 0.75,
                      gp = gpar(col = "tomato", fontsize = 12))

dev.off()
