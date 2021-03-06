#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to run the chi-square test on the GM12878 cRE-histone mark overlap results

# Create an array with the names of the results files
fileNames=( "GM12878-Promoter-Overlap.txt" "GM12878-Enhancer-Overlap.txt" "GM12878-CTCF-Overlap.txt" "GM12878-DNase-Group1-Overlap.txt" "GM12878-DNase-Group2-Overlap.txt" "GM12878-Inactive-Overlap.txt" )

# Create an array of labels, to be used in names of new files
labels=( "promoter" "enhancer" "CTCF" "DNase1" "DNase2" "inactive" )

# Make a new directory for the data
mkdir chiSquareData

# Isolate 4th column of the results files (number of overlaps) to create data files for the chi-square test 
for i in {0..5}
do
	# Grab the fourth column
	awk '{print $4}' ./GM12878OverlapResults/${fileNames[$i]} > temp.txt
	# Count the number of overlaps
	numberOfLines=`cat ./GM12878OverlapResults/${fileNames[$i]} | wc -l`
	# Subtract one
	newNumberOfLines=$(( $numberOfLines - 1 ))
	# Remove the header from the results file so there is just a list of numbers
	tail -$newNumberOfLines temp.txt > ./chiSquareData/${labels[$i]}Overlap.txt
done

rm temp.txt

# Set up results files by writing the header to the file

mkdir chiSquareResults
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./chiSquareResults/DNase2-Promoter-chisq.txt
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./chiSquareResults/DNase2-Enhancer-chisq.txt
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./chiSquareResults/DNase2-CTCF-chisq.txt
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./chiSquareResults/DNase2-DNase1-chisq.txt
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./chiSquareResults/DNase2-Inactive-chisq.txt

# Run the chi-square test
python ./chi-square-test.py

# Clean up
rm experimentNames.txt
rm peakFileNames.txt
rm targetNames.txt
