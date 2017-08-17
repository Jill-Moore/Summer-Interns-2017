#!/bin/bash
# Compares the peaks between two histone mark datasets in the same cell type for the same mark. Uses the cREs for that cell type to compare.
# Author: Will Zhang

if [ $# -eq 0 ]; then
    echo "Tool:    compare-peaks"
    echo "Summary: Compare the percent overlap between two histone mark datasets in the same cell type for the same mark."
    echo "Usage:   ./compare-peaks.sh peaks1.bed peaks2.bed"
    exit 1
fi

peaks1=$1
peaks2=$2

echo "% of " $peaks1 " that overlaps with " $peaks2 ":"
bedtools intersect -u -a $peaks1 -b $peaks2 | wc -l

echo "% of " $peaks2 " that overlaps with " $peaks1 ":"
bedtools intersect -u -a $peaks2 -b $peaks1 | wc -l


