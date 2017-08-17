#!/bin/bash
# Script to find the average peak width of the GM12878 and K562 Histone Mark peak files (similar script can be applied to any .bed file to find the average peak width or average cRE length)

# Isolate the columns .bed file names
awk '{print $1}' allHistoneFiles.txt > experimentNames.txt
awk '{print $2}' allHistoneFiles.txt > peakFileNames.txt 
awk '{print $3}' allHistoneFiles.txt > targetNames.txt

# Create an array of all the GM12878 and K562 Histone Mark file names
peakFile=( `cat "./peakFileNames.txt" `)

# Create other arrays
experiment=( `cat "./experimentNames.txt" `)
target=( `cat "./targetNames.txt" `)

# Set up results file with headers
echo -e Experiment '\t' Peak File '\t' Target '\t' Average Peak Width '\t' >> ./avgPeakWidth_Results.txt

# Cycle through all of the files to find the average peak width

for i in {0..30}
do
	# for GM12878 files (listed first in the text file)
	if [ $i -le 11 ]
	then
		# Subtract the start and end columns of the peaks from the .bed file to find the width of each peak
		awk '{print $3-$2}' ~/finalScripts/GM12878-Histone-Overlap/GM12878HistoneFiles/${peakFile[$i]} > peakWidths$i.txt 
	# for K562 files (listed after GM12878 in the text file)
	else 
		# Subtract the start and end columns of the peaks from the .bed file to find the width of each peak
		awk '{print $3-$2}' ~/finalScripts/K562-Histone-Overlap/K562HistoneFiles/${peakFile[$i]} > peakWidths$i.txt
	fi

	# Find the average of all of the peak widths and assign to a variable
        avgWidth=`awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' peakWidths$i.txt`
        # Send the values to another results file
        echo -e ${experiment[$i]} '\t' ${peakFile[$i]} '\t' ${target[$i]} '\t' $avgWidth >> ./avgPeakWidth_Results.txt
        # Clean up 
        rm peakWidths$i.txt
	
done

# Clean up
rm experimentNames.txt
rm peakFileNames.txt
rm targetNames.txt
