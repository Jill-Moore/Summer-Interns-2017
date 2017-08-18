# Author: Shaimae Elhajjajy
# Script to perform the Wilcox test for distance to TSS and cRE length

# Set up data frames for distance to TSS analysis for Promoter-like cREs that do and do not overlap with POL2
df = read.table("./chiSquare-WilcoxData/distancesToTSSoverlap_Promoter-POL2_K562.txt")
df2 = read.table("./chiSquare-WilcoxData/distancesToTSSnoOverlap_Promoter-POL2_K562.txt")

# Set up variables
x = df$V1
y = df2$V1

print("Wilcox test performed for distance to TSS of Promoter-like cREs that do and do not overlap with POL2")

wilcox.test(x, y)

# Set up data frames for distances to TSS analysis for Enhancer-like cREs that do and do not overlap with POL2
df3 = read.table("./chiSquare-WilcoxData/distancesToTSSoverlap_Enhancer-POL2_K562.txt")
df4 = read.table("./chiSquare-WilcoxData/distancesToTSSnoOverlap_Enhancer-POL2_K562.txt")

# Set up variables
x = df3$V1
y = df4$V1

print("Wilcox test performed for distance to TSS of Enhancer-like cREs that do and do not overlap with POL2")

wilcox.test(x,y)

# Set up data frames for cRE lengths analysis for Promoter-like cREs that do and do not overlap with POL2
df5 = read.table("./chiSquare-WilcoxData/cRElengthsoverlap_Promoter-POL2_K562.txt")
df6 = read.table("./chiSquare-WilcoxData/cRElengthsnoOverlap_Promoter-POL2_K562.txt")

# Set up variables
x = df5$V1
y = df6$V1

print("Wilcox test performed for cRE lengths of Promoter-like cREs that do and do not overlap with POL2")

wilcox.test(x,y)

# Setp up data frames for cRE lengths analysis for Enhancer-like cREs that do and do not overlap with POL2
df7 = read.table("./chiSquare-WilcoxData/cRElengthsoverlap_Enhancer-POL2_K562.txt")
df8 = read.table("./chiSquare-WilcoxData/cRElengthsnoOverlap_Enhancer-POL2_K562.txt")

# Set up variables
x = df7$V1
y = df8$V1

print("Wilcox test performed for cRE lengths of Enhancer-like cREs that do and do not overlap with POL2")

wilcox.test(x,y)
