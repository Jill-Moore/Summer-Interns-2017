#!/bin/bash
#Emily Earl 7/11/2017
#divideDNase
#Divide the top 25000 DNase peaks into 4 different categories depending on what they overlap
# 1. Proximal and overlaps ATAC-seq (-proximalATAC)
# 2. Proximal but does not overlap ATAC-seq (-proximalNO)
# 3. Distal and overlaps ATAC-seq (-distalATAC)
# 4. Distal but does not overlap ATAC-seq (-distalNO)
#These are saved in wherever the variable data is set to
#No arguments. Reads from a text file "list"

START=$(date +%s)

path="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison"
list="$path/Data-List.txt"
temp=~/tempHelper

data=~/dataDivideDNase

#name="FacialProminence-e11.5-cREs"
#DNase="$path/ENCFF775ETC.Mod.bed"
#ATAC="$path/ENCFF705JZG.bed"
#cREs="$path/FacialProminence-e11.5-cREs.bed"

for index in {2..13}
do
        if [ $index != 12 ]
        then

        name=`cat $list | head -$index | tail -1 | cut -f 1`
        ATAC=$path/`cat $list | head -$index | tail -1 | cut -f 2`.bed
        DNase=$path/`cat $list | head -$index | tail -1 | cut -f 3`.Mod.bed

        cREs="$path/$name-cREs.bed"

        cat $DNase | sort -k7,7rg | head -25000 > $temp/sortedDNase

        bedtools intersect -u -a $temp/sortedDNase -b $cREs > $temp/proximal
        bedtools intersect -v -a $temp/sortedDNase -b $cREs > $temp/distal

        bedtools intersect -u -a $temp/proximal -b $ATAC > $data/$name-proximalATAC
        bedtools intersect -v -a $temp/proximal -b $ATAC > $data/$name-proximalNO

        bedtools intersect -u -a $temp/distal -b $ATAC > $data/$name-distalATAC
        bedtools intersect -v -a $temp/distal -b $ATAC > $data/$name-distalNO
        fi
done
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"