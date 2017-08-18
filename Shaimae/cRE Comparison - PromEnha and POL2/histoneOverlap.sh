#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to find the overlaps between histone marks and regions of K562 Promoter-like/Enhancer-like cREs that overlap with POL2 peaks

# Prompt the user to enter the name of the file for histone mark overlapping analysis
if [ $# != 2 ]
then
        echo Enter the cell type and name of the file for which you want to perform the histone mark overlap.
        exit
fi

# Get ENCODE file information (experiment ID, peak file ID, histone mark name) from the text file
awk '{print $1}' ./$1files/$1-Histone.txt > experimentNames.txt
awk '{print $2}' ./$1files/$1-Histone.txt > peakFileNames.txt
awk '{print $3}' ./$1files/$1-Histone.txt > targetNames.txt

# Create arrays for each of the three types of file information from above
experiment=( `cat "experimentNames.txt" `)
peakFile=( `cat "peakFileNames.txt" `)
target=( `cat "targetNames.txt" `)

# Strip the ".bed" extension from the cRE file name
fileName=`basename $2 .bed`

# Set up the header of the results file
echo -e Experiment '\t' Peak File '\t' Target '\t' \# Overlaps '\t' Percent Overlap >> ./$1results/histone$fileName.txt

# Find the number of histone marks that will be intersected
numberOfHistoneMarks=`cat "targetNames.txt" | wc -l`

# Find the upper limit of the range of the for loop
limit=$(( $numberOfHistoneMarks - 1 ))

# Cycle through each histone mark file and intersect with each cRE to find the percent overlap

for i in $(seq 0 $limit)
do
	# Find the number of intersections between the Promoter-like/Enhancer-like cREs that overlap with POL2 peaks and the histone marks
        numberOfOverlaps=$( bedtools intersect -u -a ./$2 -b ../$1-Histone-Overlap/$1HistoneFiles/${peakFile[$i]}.bed | wc -l )
	# Find the total number of Promoter-like/Enhancer-like cREs that overlap with POL2 peaks
        totalcREs=$( wc -l ./$2 | cut -f 1 -d ' ')
        # Calculate the percent overlap between the cREs and the histone marks
        percentOverlap=$(awk "BEGIN {printf \"%.2f\", $numberOfOverlaps / $totalcREs * 100 }")	

	echo -e ${experiment[$i]} '\t' ${peakFile[$i]} '\t' ${target[$i]} '\t' $numberOfOverlaps '\t' $percentOverlap >> ./$1results/histone$fileName.txt

done
