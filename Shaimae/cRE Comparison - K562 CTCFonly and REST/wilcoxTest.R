# Author: Shaimae Elhajjajy
# Script to perform the Wilcox test for distance to TSS and cRE length

# Set up data frames for distance to TSS analysis
df = read.table("./chiSquare-WilcoxData/distancesToTSSoverlap.txt")
df2 = read.table("./chiSquare-WilcoxData/distancesToTSSnoOverlap.txt")

# Set up variables
x = df$V1
y = df2$V1

print("Wilcox test performed for distance to TSS")

wilcox.test(x, y)

# Set up data frames for cRE lengths analysis
df3 = read.table("./chiSquare-WilcoxData/cRElengthsoverlap.txt")
df4 = read.table("./chiSquare-WilcoxData/cRElengthsnoOverlap.txt")

w = df3$V1
z = df4$V1

print("Wilcox test performed for cRE length")

wilcox.test(w, z)
