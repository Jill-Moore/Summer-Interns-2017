#!/bin/bash
# Compares the peaks between two histone mark datasets in the same cell type for the same mark. Uses the cREs for that cell type to compare.
# Author: Will Zhang

if [ $# -eq 0 ]; then
    echo "Tool:    compare-peaks"
    echo "Summary: Compare the percent overlap between two histone mark datasets in the same cell type for the same mark. Generate scatterplots that compare signals over each peak."
    echo "Usage:   ./compare-peaks.sh peaks1.bed peaks2.bed [signal1.bigwig] [signal2.bigwig]"
    exit 1
fi

### Compute number of peaks and intersection ###

peaks1=$1
peaks2=$2

numpeaks=$( cat $peaks1 | wc -l )
overlap=$( bedtools intersect -u -a $peaks1 -b $peaks2 | wc -l )
percent=$( echo "scale=2; 100 * $overlap / $numpeaks" | bc )
echo $peaks1
echo "  total peaks: "$numpeaks
echo "  percent overlap: "$percent" %"

numpeaks=$( cat $peaks2 | wc -l )
overlap=$( bedtools intersect -u -a $peaks2 -b $peaks1 | wc -l )
percent=$( echo "scale=2; 100 * $overlap / $numpeaks" | bc )
echo $peaks2
echo "  total peaks: "$numpeaks
echo "  percent overlap: "$percent" %"

### Generate scatterplots comparing signals between each lab over each peak ###

