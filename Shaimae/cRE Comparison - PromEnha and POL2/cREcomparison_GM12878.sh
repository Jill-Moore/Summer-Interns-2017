#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to perform the cRE comparison analysis, with GM12878 Promoter- and Enhancer-like cREs and GM12878 POL2 ChIP-seq peaks

# Find the promoter-like cREs that overlap with POL2 ChIP-seq peaks
bedtools intersect -u -a ./GM12878files/GM12878-Promoter.bed -b ./GM12878files/ENCFF120VUT.bed -wa > ./overlap_Promoter-POL2_GM12878.bed

# Find the promoter-like cREs that do NOT overlap with POL2 ChIP-seq peaks
bedtools intersect -a ./GM12878files/GM12878-Promoter.bed -b ./GM12878files/ENCFF120VUT.bed -v > ./noOverlap_Promoter-POL2_GM12878.bed

# Find the enhancer-like cREs that overlap with POL2 ChIP-seq peaks
bedtools intersect -u -a ./GM12878files/GM12878-Enhancer.bed -b ./GM12878files/ENCFF120VUT.bed -wa > ./overlap_Enhancer-POL2_GM12878.bed

# Find the enhancer-like cREs that do NOT overlap with POL2 ChIP-seq peaks
bedtools intersect -a ./GM12878files/GM12878-Enhancer.bed -b ./GM12878files/ENCFF120VUT.bed -v > ./noOverlap_Enhancer-POL2_GM12878.bed

# Perform Histone Mark overlap
./histoneOverlap.sh GM12878 ./overlap_Promoter-POL2_GM12878.bed
./histoneOverlap.sh GM12878 ./noOverlap_Promoter-POL2_GM12878.bed
./histoneOverlap.sh GM12878 ./overlap_Enhancer-POL2_GM12878.bed
./histoneOverlap.sh GM12878 ./noOverlap_Enhancer-POL2_GM12878.bed

# Set up the data for the chi-square test

# Grab the fourth column with number of overlaps
awk '{print $4}' ./GM12878results/histoneoverlap_Promoter-POL2_GM12878.txt > temp.txt
# Count the number of overlaps
numberOfLines=`cat ./GM12878results/histoneoverlap_Promoter-POL2_GM12878.txt | wc -l`
# Subtract one
newNumberOfLines=$(( $numberOfLines - 1 ))
# Remove the header from the results file so there is just a list of numbers
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histoneoverlap_Promoter-POL2_GM12878.txt

awk '{print $4}' ./GM12878results/histonenoOverlap_Promoter-POL2_GM12878.txt > temp.txt
numberOfLines=`cat ./GM12878results/histonenoOverlap_Promoter-POL2_GM12878.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histonenoOverlap_Promoter-POL2_GM12878.txt

awk '{print $4}' ./GM12878results/histoneoverlap_Enhancer-POL2_GM12878.txt > temp.txt
numberOfLines=`cat ./GM12878results/histoneoverlap_Enhancer-POL2_GM12878.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histoneoverlap_Enhancer-POL2_GM12878.txt

awk '{print $4}' ./GM12878results/histonenoOverlap_Enhancer-POL2_GM12878.txt > temp.txt
numberOfLines=`cat ./GM12878results/histonenoOverlap_Enhancer-POL2_GM12878.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histonenoOverlap_Enhancer-POL2_GM12878.txt
rm temp.txt

# Set up the results files by writing the header to the file
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./GM12878results/promoterChiSquare.txt
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./GM12878results/enhancerChiSquare.txt

# Perform chi-square test
python chi-square-test-GM12878.py

# Find the average distance to TSS for all data sets
./avgDistanceTSS.sh GM12878 ./overlap_Promoter-POL2_GM12878.bed
./avgDistanceTSS.sh GM12878 ./noOverlap_Promoter-POL2_GM12878.bed
./avgDistanceTSS.sh GM12878 ./overlap_Enhancer-POL2_GM12878.bed
./avgDistanceTSS.sh GM12878 ./noOverlap_Enhancer-POL2_GM12878.bed

# Find the average length of cREs for all data sets
./avgcRElength.sh GM12878 ./overlap_Promoter-POL2_GM12878.bed
./avgcRElength.sh GM12878 ./noOverlap_Promoter-POL2_GM12878.bed
./avgcRElength.sh GM12878 ./overlap_Enhancer-POL2_GM12878.bed
./avgcRElength.sh GM12878 ./noOverlap_Enhancer-POL2_GM12878.bed

# Run Wilcox test in R for both average distance to TSS and average length of cREs
Rscript wilcoxTestGM12878.R >> ./GM12878results/wilcoxTest.txt

# Clean up
rm experimentNames.txt
rm peakFileNames.txt
rm targetNames.txt
