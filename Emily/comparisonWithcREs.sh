#!/bin/bash
#Emily Earl 6/27/2017
#comparisonWithcREs
#This script will compare cREs to DNase and ATAC-seq data. The information 
# gathered for each tissue will be:
# 1. Number of cREs, 
# 2. number of cREs that do not overlap DNase peaks, 3. % cREs that do not overlap DNase peaks,
# 4. number of cREs that do not overlap ATAC-seq peaks, 5. % cREs that do not overlap ATAC-seq peaks,
# % of the cREs that don't overlap with DNase peaks that are 6. promoter-like, 7. enhancer-like, 8. DNase-only,
# % of the cREs that don't overlap with ATAC-seq peaks that are 9. promoter-like, 10. enhancer-like, 11. DNase-only

#No arguments, reads a text file with the names of the files

START=$(date +%s)

path="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison"
echo Comparison with cREs > comparisonWithcREs.csv

for tissueNum in {2..13}
do
        output=`cat $path/Data-List.txt | head -$tissueNum | tail -1 | cut -f 1`
        cRE="$path/$output-cREs.bed"
        output="$output, "
        DNase=`cat $path/Data-List.txt | head -$tissueNum | tail -1 | cut -f 3`
        DNase="$path/$DNase.bed"

        ATAC=`cat $path/Data-List.txt | head -$tissueNum | tail -1 | cut -f 2`
        ATAC="$path/$ATAC.bed"

        num=`cat $cRE | wc -l`
        output="$output $num, "

        num=`bedtools intersect -v -a $cRE -b $DNase | wc -l`
        output="$output $num, "

        num=`bedtools intersect -v -a $cRE -b $ATAC | wc -l`
        output="$output $num, "

        #Get types for DNase
        num=`bedtools intersect -v -a $cRE -b $DNase | grep "255,0,0" | wc -l`
        output="$output $num, "
        num=`bedtools intersect -v -a $cRE -b $DNase | grep "255,205,0" | wc -l`
        output="$output $num, "
        num=`bedtools intersect -v -a $cRE -b $DNase | grep "6,218,147" | wc -l`
        output="$output $num, "

        #Get types for ATAC
         num=`bedtools intersect -v -a $cRE -b $ATAC | grep "255,0,0" | wc -l`
        output="$output $num, "
        num=`bedtools intersect -v -a $cRE -b $ATAC | grep "255,205,0" | wc -l`
        output="$output $num, "
        num=`bedtools intersect -v -a $cRE -b $ATAC | grep "6,218,147" | wc -l`
        output="$output $num"
        echo $output >>comparisonWithcREs.csv
        echo $tissueNum
done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"