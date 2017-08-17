#!/bin/bash
#Emily Earl 7/12/2017
#exonPercentage
#This will get the percentage of the peaks that overlap exons. This specifically uses the folder
# made from running divideDNase

START=$(date +%s)

exons="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison/Exons.bed"
data=~/dataDivideDNase

echo "File" $'\t' "Overlap with Exons" > exonOverlap.tsv

for index in {1..44}
do

	fileName=` ls $data | head -$index | tail -1 `
	file=$data/$fileName

	overlap=`bedtools intersect -u -a $file -b $exons | wc -l`
	lines=`cat $file | wc -l`

	
	echo $fileName $overlap $lines | awk '{print $1 "\t" ($2/$3)}' >> exonOverlap.tsv

done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"