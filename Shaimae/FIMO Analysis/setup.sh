#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to reconfigure the .bed file, so that it can be sorted and successfully uploaded to the UCSC Genome Browser to obtain the sequence

# Prompt the user to enter the file information on the command line
if [ $# != 2 ]
then
	echo Please enter the file information on the command line: experiment ID and peak file ID
	exit
fi

# Copy the file to a local directory
cp /data/projects/encode/data/$1/$2.bed.gz ./

# Unzip the file
gunzip $2.bed.gz

# Sort the file, first by p-value then by signal (in descending order)
sort -k 8,8n -k 7,7 -n -r $2.bed > file.txt
# Separate all columns with a tab (for neatness) and save to a new file
column -t file.txt > sorted$2.bed
# Clean up
rm file.txt

# Create a new file with just four columns (so that it can be uploaded to the UCSC Genome Browser), with the last column being a Peak ID
awk '{print $1 "\t" $2 "\t" $3 "\t" "Peak_"NR}' sorted$2.bed > final$2.bed

# Next step:
# - Copy the new final$2.bed file onto your Desktop (using scp)
# - Upload to the UCSC Genome Browser (Custom Tracks) to get the DNA sequences of the peaks
# - Copy the sequence file from your Desktop back to the server (using scp)
# - Continue by using fimoAnalysis.sh
