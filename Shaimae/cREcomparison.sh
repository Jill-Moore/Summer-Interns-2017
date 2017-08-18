#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to perform the second cRE comparison analysis, with K562 CTCF-only cREs and K562 REST ChIP-seq peaks from the Snyder Lab

# Find the CTCF-only cREs that overlap with Snyder's REST ChIP-seq peaks
bedtools intersect -u -a ./K562-CTCF.bed -b ./ENCFF895QLA.bed -wa > ./overlap.bed

# Find the CTCF-only cREs that do NOT overlap with Snyder's REST ChIP-seq peaks
bedtools intersect -a ./K562-CTCF.bed -b ./ENCFF895QLA.bed -v > ./noOverlap.bed

# Perform TF overlap
./TFoverlap.sh overlap.bed
./TFoverlap.sh noOverlap.bed

# Perform Histone Mark overlap
./histoneOverlap.sh overlap.bed
./histoneOverlap.sh noOverlap.bed

# Set up the data for the chi-square test

# Grab the fourth column with number of overlaps
awk '{print $4}' ./results/TFoverlap.txt > temp.txt
# Count the number of overlaps
numberOfLines=`cat ./results/TFoverlap.txt | wc -l`
# Subtract one
newNumberOfLines=$(( $numberOfLines - 1 ))
# Remove the header from the results file so there is just a list of numbers
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/TFoverlap.txt

awk '{print $4}' ./results/TFnoOverlap.txt > temp.txt
numberOfLines=`cat ./results/TFnoOverlap.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/TFnoOverlap.txt

awk '{print $4}' ./results/histoneoverlap.txt > temp.txt
numberOfLines=`cat ./results/histoneoverlap.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histoneoverlap.txt

awk '{print $4}' ./results/histonenoOverlap.txt > temp.txt
numberOfLines=`cat ./results/histonenoOverlap.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histonenoOverlap.txt
rm temp.txt

# Set up the results files by writing the header to the file
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./results/TFchisquare.txt
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./results/histoneChiSquare.txt

# Perform chi-square test
python chi-square-test.py

# Find the average distance to TSS for both data sets
./avgDistanceTSS.sh overlap.bed
./avgDistanceTSS.sh noOverlap.bed

# Find the average length of cREs for both data sets
./avgcRElength.sh overlap.bed
./avgcRElength.sh noOverlap.bed

# Run Wilcox test in R for both average distance to TSS and average length of cREs
Rscript wilcoxTest.R >> ./results/wilcoxTest.txt

# Clean up
rm experimentNamesTF.txt
rm peakFileNamesTF.txt
rm targetNamesTF.txt
rm experimentNamesHistone.txt
rm peakFileNamesHistone.txt
rm targetNamesHistone.txt
