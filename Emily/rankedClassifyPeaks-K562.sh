#!/bin/bash
#Emily Earl 8/10/2017
#rankedClassifyPeaks-K562
#Originally made to get data for K562 labs
#Split the 2 experiments into 500 bins. Intersect with the different cREs 
#To ensure that they only overlap with one, have the hierarchy be 
# enhancers, promoters (that aren't enhancers), 
# CTCF-only (that aren't the first 2), DNase-only (that isn't the first 3)
#Take 2 arguments and that will be the file with the peaks sorted by p-value and name for saving
#Uses temporary storage tempHelper/tempSplit

START=$(date +%s)

cREs=/data/projects/rusers/Emily-2017/ENCODE-QC/Human
file=$1
temp=tempHelper/tempSplit
#The working files are in ~/human/ and are Bernstein_K562.bed and Farnham_K562.bed

echo Bin $'\t' Enhancer $'\t' Promoter $'\t' CTCF $'\t' DNase $'\t' Total > $2_bins.tsv


for bin in {500..20000..500}
do
	cat $file | head -$bin | tail -500 > $temp/total
	
	enh=`bedtools intersect -u -a $temp/total -b $cREs/K562-Enhancer.bed | wc -l`
	bedtools intersect -v -a $temp/total -b $cREs/K562-Enhancer.bed > $temp/noEnh
	
	pro=`bedtools intersect -u -a $temp/noEnh -b $cREs/K562-Promoter.bed | wc -l`
	bedtools intersect -v -a $temp/noEnh -b $cREs/K562-Promoter.bed > $temp/noPro

	CTCF=`bedtools intersect -u -a $temp/noPro -b $cREs/K562-CTCF.bed | wc -l`
	bedtools intersect -v -a $temp/noPro -b $cREs/K562-CTCF.bed > $temp/noCTCF

	DNase=`bedtools intersect -u -a $temp/noCTCF -b $cREs/K562-CTCF.bed | wc -l`
	# bedtools intersect -v -a $temp/noCTCF -b $cREs/K562-CTCF.bed | wc -l

	echo $bin $'\t' $enh $'\t' $pro $'\t' $CTCF $'\t' $DNase$'\t' $(( $enh + $pro + $CTCF + $DNase)) >> $2_bins.tsv



	echo Done $bin
done



END=$(date +%s)
DIFF=$(( $END - $START ))
echo This script took $DIFF seconds
echo This script took $(( $DIFF / 60 )) minutes