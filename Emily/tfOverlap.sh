#!/bin/bash
#Emily Earl 7/25/2017
#tfCompare
#Compare one tissue type to all the transcription factors
#Run splitDNaseATAC first to get the correct files to work on
#Need a folder of Transcription factors, a place where the top 50000 peaks are split (by splitDNaseATAC), and also a save folder
#One argument: The tissue timepoint which is the start of the name of the files
# which are split into 
# A: ATAC-seq peaks that are overlapped by DNase peaks
# B: ATAC-seq peaks that are NOT overlapped by DNase peaks
# C: DNase peaks that are overlapped by ATAC-seq peaks
# D: DNase peaks that are NOT overlapped by ATAC-seq peaks

START=$(date +%s)

if [ $# != 1 ] 
then
	echo Need 1 argument, which is the tissue timepoint name and is the start of the -ATAC-with-D.bed etc files

	exit 1
fi

list="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison/K562-TF.txt"
tfFolder=~/TranscriptionFactors
data=~/splitTop50000Intersect
save=~/tfOverlap/$1-tfOverlap.tsv
temp=~/tfOverlap/temp

echo $1 > $save

#Only using one tissue

	ATACwithD=$data/$1-ATAC-with-D.bed		#A
	ATACwoD=$data/$1-ATAC-wo-D.bed			#B
	DNasewithA=$data/$1-DNase-with-A.bed	#C
	DNasewoA=$data/$1-DNase-wo-A.bed		#D

	Alen=`cat $ATACwithD | wc -l`
	Blen=`cat $ATACwoD | wc -l`
	Clen=`cat $DNasewithA | wc -l`
	Dlen=`cat $DNasewoA | wc -l`


for ind in {1..307}
do
	col1=`cat $list | head -$ind | tail -1 | cut -f 1`
	col2=`cat $list | head -$ind | tail -1 | cut -f 2`
	name=`cat $list | head -$ind | tail -1 | cut -f 3`

	tf=$tfFolder/$name-$col2.bed

	A=`bedtools intersect -u -a $ATACwithD -b $tf | wc -l`
	B=`bedtools intersect -u -a $ATACwoD -b $tf | wc -l`
	C=`bedtools intersect -u -a $DNasewithA -b $tf | wc -l`
	D=`bedtools intersect -u -a $DNasewoA -b $tf | wc -l`

	echo $name $'\t' $col1 $'\t' $col2 $'\t' $A $'\t' $Alen $'\t' $B $'\t' $Blen $'\t' $C $'\t' $Clen $'\t' $D $'\t' $Dlen >> $temp
	
	echo Done with $ind
done

cat $temp| awk 'BEGIN{OFS="\t"} { \
	print $1, $2, $3, $4, $5, ($4/$5), $6, $7, ($6/$7), $8, $9, ($8/$9), $10, $11, ($10/$11)}' > $save

rm $temp

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"