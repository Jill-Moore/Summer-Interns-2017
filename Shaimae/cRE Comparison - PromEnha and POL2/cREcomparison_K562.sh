#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to perform the cRE comparison analysis, with K562 Promoter- and Enhancer-like cREs and K562 POL2 ChIP-seq peaks

# Find the promoter-like cREs that overlap with POL2 ChIP-seq peaks
bedtools intersect -u -a ./K562files/K562-Promoter.bed -b ./K562files/ENCFF248IWJ.bed -wa > ./overlap_Promoter-POL2_K562.bed

# Find the promoter-like cREs that do NOT overlap with POL2 ChIP-seq peaks
bedtools intersect -a ./K562files/K562-Promoter.bed -b ./K562files/ENCFF248IWJ.bed -v > ./noOverlap_Promoter-POL2_K562.bed

# Find the enhancer-like cREs that overlap with POL2 ChIP-seq peaks
bedtools intersect -u -a ./K562files/K562-Enhancer.bed -b ./K562files/ENCFF248IWJ.bed -wa > ./overlap_Enhancer-POL2_K562.bed

# Find the enhancer-like cREs that do NOT overlap with POL2 ChIP-seq peaks
bedtools intersect -a ./K562files/K562-Enhancer.bed -b ./K562files/ENCFF248IWJ.bed -v > ./noOverlap_Enhancer-POL2_K562.bed

# Perform Histone Mark overlap
./histoneOverlap.sh K562 ./overlap_Promoter-POL2_K562.bed 
./histoneOverlap.sh K562 ./noOverlap_Promoter-POL2_K562.bed
./histoneOverlap.sh K562 ./overlap_Enhancer-POL2_K562.bed
./histoneOverlap.sh K562 ./noOverlap_Enhancer-POL2_K562.bed

# Set up the data for the chi-square test

# Grab the fourth column with number of overlaps
awk '{print $4}' ./K562results/histoneoverlap_Promoter-POL2_K562.txt > temp.txt
# Count the number of overlaps
numberOfLines=`cat ./K562results/histoneoverlap_Promoter-POL2_K562.txt | wc -l`
# Subtract one
newNumberOfLines=$(( $numberOfLines - 1 ))
# Remove the header from the results file so there is just a list of numbers
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histoneoverlap_Promoter-POL2_K562.txt

awk '{print $4}' ./K562results/histonenoOverlap_Promoter-POL2_K562.txt > temp.txt
numberOfLines=`cat ./K562results/histonenoOverlap_Promoter-POL2_K562.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histonenoOverlap_Promoter-POL2_K562.txt

awk '{print $4}' ./K562results/histoneoverlap_Enhancer-POL2_K562.txt > temp.txt
numberOfLines=`cat ./K562results/histoneoverlap_Enhancer-POL2_K562.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histoneoverlap_Enhancer-POL2_K562.txt

awk '{print $4}' ./K562results/histonenoOverlap_Enhancer-POL2_K562.txt > temp.txt
numberOfLines=`cat ./K562results/histonenoOverlap_Enhancer-POL2_K562.txt | wc -l`
newNumberOfLines=$(( $numberOfLines - 1 ))
tail -$newNumberOfLines temp.txt > ./chiSquare-WilcoxData/histonenoOverlap_Enhancer-POL2_K562.txt
rm temp.txt

# Set up the results files by writing the header to the file
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./K562results/promoterChiSquare.txt
echo -e Experiment '\t' Peak File '\t' Target '\t' chi-squared value '\t' p-value > ./K562results/enhancerChiSquare.txt

# Perform chi-square test
python chi-square-test-K562.py

# Find the average distance to TSS for all data sets
./avgDistanceTSS.sh K562 ./overlap_Promoter-POL2_K562.bed
./avgDistanceTSS.sh K562 ./noOverlap_Promoter-POL2_K562.bed
./avgDistanceTSS.sh K562 ./overlap_Enhancer-POL2_K562.bed
./avgDistanceTSS.sh K562 ./noOverlap_Enhancer-POL2_K562.bed

# Find the average length of cREs for all data sets
./avgcRElength.sh K562 ./overlap_Promoter-POL2_K562.bed
./avgcRElength.sh K562 ./noOverlap_Promoter-POL2_K562.bed
./avgcRElength.sh K562 ./overlap_Enhancer-POL2_K562.bed
./avgcRElength.sh K562 ./noOverlap_Enhancer-POL2_K562.bed

# Run Wilcox test in R for both average distance to TSS and average length of cREs
Rscript wilcoxTestK562.R >> ./K562results/wilcoxTest.txt

# Clean up
rm experimentNames.txt
rm peakFileNames.txt
rm targetNames.txt
