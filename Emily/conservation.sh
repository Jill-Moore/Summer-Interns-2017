#!/bin/bash
#Emily Earl 7/12/2017
#conservation
#Run divideDNase first!
#This will get files after running bigWigAverageOverBed and from there we can get mean Conservation score
#No arguments. Will read the files in the folder made by divideDNase

START=$(date +%s)

path="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison"
mm10="$path/mm10.60way.phastCons.bw"


for index in {1..44}
do
        file=`ls dataDivideDNase/ | head -$index | tail -1`

        awk '{print $1 "\t" $2 "\t" $3 "\t" $4}' ~/dataDivideDNase/$file > ~/tmp.bed
        $path/bigWigAverageOverBed $mm10 ~/tmp.bed ~/dataConservation/$file-conserv

done



END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"
