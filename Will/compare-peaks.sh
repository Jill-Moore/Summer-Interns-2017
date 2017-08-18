#!/bin/bash
# Compares the peaks between two histone mark datasets in the same cell type for the same mark. Uses the cREs for that cell type to compare.
# Author: Will Zhang

if [ $# -eq 0 ]; then
    echo "Tool:         compare-peaks"
    echo "Summary:      Compare the percent overlap between two histone mark datasets in the same cell type for the same mark. Generate scatterplots that compare signals over each peak."
    echo "Usage:        ./compare-peaks.sh peaks1.bed peaks2.bed [signal1.bigwig signal2.bigwig]"
    echo "Dependencies: bigWigAverageOverBed" 
    exit 1
fi

### Validate arguments ###

peaks1=$1
peaks2=$2
signal1=""
signal2=""

# Test peaks are BED files
if [ ${peaks1: -4} != ".bed" ] || [ ${peaks2: -4} != ".bed" ]
then
    echo "Error: peaks are not BED files."
    exit 1
fi

# Test signals are bigWig files
if [ $# -eq 4 ]; then
    signal1=$3
    signal2=$4
    
    if [ ${signal1: -7} != ".bigwig" ] || [ ${signal2: -7 } != ".bigwig" ]
    then
        echo "Error: signals are not bigWig files."
        exit 1
    fi
fi

# Test invalid number of arguments
if [ $# != 2 ] && [ $# != 4 ]
then
    echo "Invalid number of arguments."
    exit 1
fi

### Compute number of peaks and intersections ###

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

if [ $# -eq 4 ]; then
    echo "Generating peak 1 ("$peaks1") scatterplot ... "
    cat $peaks1 | awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,"Peak-"NR}' > tmp.peaks1.bed

    bigWigAverageOverBed $signal1 tmp.peaks1.bed peaks1.signal1.results.bed
    bigWigAverageOverBed $signal2 tmp.peaks1.bed peaks1.signal2.results.bed

    echo "Generating peak 2 ("$peaks2") scatterplot ... "
    cat $peaks2 | awk 'BEGIN{FS="\t";OFS="\t"}{print $1,$2,$3,"Peak-"NR}' > tmp.peaks2.bed

    bigWigAverageOverBed $signal1 tmp.peaks2.bed peaks2.signal1.results.bed
    bigWigAverageOverBed $signal2 tmp.peaks2.bed peaks2.signal2.results.bed

    echo "Done."
fi
