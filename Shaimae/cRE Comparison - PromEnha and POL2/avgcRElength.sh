#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to find the mean length of cREs

if [ $# != 2 ]
then
	echo Enter the name of the cell type and the file for which you want to find the average cRE length.
	# Files entered should be Promoter-like/Enhancer-like cREs that do/do not overlap with POL2
	exit
fi

# Strip the ".bed" extension from the cRE file name
fileName=`basename $2 .bed`

# Find the length of all cREs in the file by subtracting the start and end locations
awk '{print $3-$2}' $2 > ./chiSquare-WilcoxData/cRElengths$fileName.txt
# Find the average cRE length
avg_cRE_length=`awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' ./chiSquare-WilcoxData/cRElengths$fileName.txt`
# Write the results to a file
echo -e $fileName '\t' $avg_cRE_length >> ./$1results/avgcRElength.txt
