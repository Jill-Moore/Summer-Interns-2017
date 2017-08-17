#!/bin/bash
#Emily Earl 6/15/2017 redone 7/10/2017
#basicStats
#This script will get basic stats of ATAC-seq peaks, including
# number of ATAC-seq Peaks, Average Width, Average FDR, number of Overlaps with cREs,
# and Percent Overlap with cREs
#No arguments, run by reading a text file with the names of the files

START=$(date +%s)

echo "ENCODE ID, Description, # ATAC-seq Peaks, Average Width, Average FDR, # Overlap with cREs, Percent Overlap" > basicStats.csv

path="/data/projects/rusers/Emily-2017"
cREs="$path/mm10-cREs.bed"
list="$path/File-List.txt" #the text file to read

for index in {1..27}
do
	file=`cat $list | head -$index | tail -1 | cut -c -11`
	description=`cat $list | head -$index | tail -1 | cut -f 2`
	fileName="$path/$file.bed"


peaks=`cat $fileName | wc -l`

#totalWidth
width=`cat $fileName | awk ' BEGIN { sum=0} \
{sum+=$3-$2; \
lines++} \
END{print (sum/lines)}'`

FDR=`cat $fileName | awk ' BEGIN { sum=0} \
{sum+=$9; \
lines++} \
END{print (sum/lines)}'`

overlaps=`bedtools intersect -u -a $fileName -b $cREs | wc -l`



echo "$file, $description, $peaks, $width, $FDR, $overlaps, `echo $overlaps $peaks | awk 'BEGIN{FS=" "} {print ($1 / $2)}'`" >> ~/myData/basicStats.csv
done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"