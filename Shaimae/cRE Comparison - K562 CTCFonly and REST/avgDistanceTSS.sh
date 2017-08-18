#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to find the mean distance from the TSS for K562

# Prompt the user to enter the name of the file.
if [ $# != 1 ]
then
	echo Enter the name of the file for which you want to find the average distance to the TSS.
	# Files entered should be CTCF-only cREs that overlap and don't overlap with REST.
	exit
fi

# Strip the ".bed" extension from the cRE file name
fileName=`basename $1 .bed`

# Set up the header of the results file
echo -e cRE File '\t' Average Distance to TSS >> ./results/avgDistToTSS.txt

# Perform bedtools closest to find the closest distance between the cREs and the TSSs in file "-b"
bedtools closest -d -a $1 -b ./TSS.Filtered.bed > distances.txt
# Grab the last column, which is the distance (in base pairs) between the cREs and the closest TSS
awk '{ print $13 }' distances.txt > ./chiSquare-WilcoxData/distancesToTSS$fileName.txt
# Find the average distance to the TSS
avg_dist_TSS=`awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' ./chiSquare-WilcoxData/distancesToTSS$fileName.txt`
# Write the results to a file
echo -e $fileName '\t' $avg_dist_TSS >> ./results/avgDistToTSS.txt

# Clean up
rm distances.txt
