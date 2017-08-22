#!/bin/bash
#Emily Earl 8/3/17
#classifyPeaks-histoneOnly
#Originally for histone-only data
#This will figure out the number of cREs for each tissue are 
#promoters, enhancers, CTCF-only, or unclassified - variables begin with "tot"
#and also the number of the H3K4me1 peaks that intersect the cREs in each of those categories - variables begin with "num"
#Directory tHistone is in my local directory where I copy the peaks into. 
#Also uses temporary directories tempHelper/histoneTemp/

START=$(date +%s)

path="/data/projects/rusers/Emily-2017/ENCODE-QC"
list="/data/projects/rusers/Emily-2017/ENCODE-QC/HistoneOnly.txt"



echo -n > tempHelper/histoneTemp
for ind in {1..18}
do
	col2=`cat $list | head -$ind | tail -1 | cut -f 2`
	col3=`cat $list | head -$ind | tail -1 | cut -f 3`
	col4=`cat $list | head -$ind | tail -1 | cut -f 4`

	cp /data/projects/encode/data/$col3/$col4.bed.gz tHistone/bed$ind.gz
	gunzip tHistone/bed$ind.gz

	bedtools intersect -u -a $path/cREs/*$col2*.bed -b tHistone/bed$ind > output.txt

	numPro=`grep "255,0,0" output.txt | wc -l`
	totPro=`grep "255,0,0" $path/cREs/*$col2*.bed | wc -l`
	
	numEnh=`grep "255,205,0" output.txt | wc -l`
	totEnh=`grep "255,205,0" $path/cREs/*$col2*.bed | wc -l`

	numCTCF=`grep "0,176,240" output.txt | wc -l`
	totCTCF=`grep "0,176,240" $path/cREs/*$col2*.bed | wc -l`

	numUn=`grep "140,140,140" output.txt | wc -l`
	totUn=`grep "140,140,140" $path/cREs/*$col2*.bed | wc -l`

	echo $totPro $numPro $totEnh $numEnh $totCTCF $numCTCF $totUn $numUn >> tempHelper/histoneTemp

	echo Done $ind
done

echo -n > histoneOnly.tsv
cat tempHelper/histoneTemp | awk 'BEGIN { FS=" "; OFS="\t"} \
{if($5==0){ \
	print $1,$2,($2/$1)," ",$3,$4,($4/$3)," ",$5,$6,0," ",$7,$8,($8/$7)} \
else \
	print $1,$2,($2/$1)," ",$3,$4,($4/$3)," ",$5,$6,($6/$5)," ",$7,$8,($8/$7)}' >> histoneOnly.tsv

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"