#!/bin/bash
#Emily Earl 7/20/2017
#splitDNaseATAC
#This script will split ATAC-seq peaks and DNase peaks into:
# A: ATAC-seq peaks that are overlapped by DNase peaks
# B: ATAC-seq peaks that are NOT overlapped by DNase peaks
# C: DNase peaks that are overlapped by ATAC-seq peaks
# D: DNase peaks that are NOT overlapped by ATAC-seq peaks

#No arguments. Reads from a text file. Needs folder made to save it in there

START=$(date +%s)


path="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison"
list="$path/Data-List.txt"
folder=~/dataSplitDNaseATAC

for ind in {2..13}
do
	if [ $ind != 12 ]
		then
		tissue=`cat $list | head -$ind | tail -1 | cut -f 1`
		ATAC=`cat $list | head -$ind | tail -1 | cut -f 2`
		DNase=`cat $list | head -$ind | tail -1 | cut -f 3`

		ATACfile="$path/$ATAC.bed"
		DNasefile="$path/$DNase.Mod.bed"

		bedtools intersect -u -a $ATACfile -b $DNasefile > $folder/$tissue-A-with-D	#A
		bedtools intersect -v -a $ATACfile -b $DNasefile > $folder/$tissue-A-wo-D	#B

		bedtools intersect -u -a $DNasefile -b $ATACfile > $folder/$tissue-D-with-A	#C
		bedtools intersect -v -a $DNasefile -b $ATACfile > $folder/$tissue-D-wo-A	#D

	fi
	echo Done with $ind
done

END=$(date +%s)
DIFF=$(($END - $START))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"