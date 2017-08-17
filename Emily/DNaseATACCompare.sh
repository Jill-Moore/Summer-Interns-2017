#!/bin/bash
#Emily Earl 7/6/17
#DNaseATACCompare
#This will do a side by side comparison of ATAC-seq peaks and DNase peaks for 12 tissues in mouse
#The information gathered will be Number of peaks, Average peak width, % Proximal, and % overlap with the other 
#No parameters. Will read from a text file that has the names. The columns are
# Tissue Timepoint, ATAC-seq Peak ENCODE ID, DNase peak ENCODE ID

START=$(date +%s)

path="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison"
list="$path/Data-List.txt"
prox="$path/TSS.Filtered.4K.bed"

echo Comparison with DNase > compareWithDNase.csv
echo Data For DNase > ~/tempHelper/temp
for tissueNum in {2..13}
do
        tisTime=`head -$tissueNum $list |tail -1| cut -f 1`
        ATAC="$path/`head -$tissueNum $list |tail -1| cut -f 2`.bed"
        DNase="$path/`head -$tissueNum $list |tail -1| cut -f 3`.bed"

        APeaks=`cat $ATAC | wc -l`
        APerc=`bedtools intersect -u -a $ATAC -b $prox | wc -l`

        DPeaks=`cat $DNase | wc -l`
        DPerc=`bedtools intersect -u -a $ATAC -b $prox | wc -l`

        AWidth=`cat $ATAC | awk 'BEGIN{ sum=0; \
                numLines=0;} \
                {sum+=$3-$2; \
                numLines++;} \
                END{print (sum/numLines)}'`
        DWidth=`cat $DNase | awk 'BEGIN{ sum=0; \
                numLines=0;} \
                {sum+=$3-$2; \
                numLines++;} \
                END{print (sum/numLines)}'`

        AwithD=`bedtools intersect -u -a $ATAC -b $DNase | wc -l`
        DwithA=`bedtools intersect -u -a $DNase -b $ATAC | wc -l`

        echo $tisTime, $APeaks, $AWidth, $APerc, $AwithD, \
        $DPeaks, $DWidth, $DPerc, $DwithA >> ~/tempHelper/temp

        echo Done with $tissueNum       
done

`cat ~/tempHelper/temp | awk ' \
BEGIN{ \
        OFS=", "; \
        FS=", " \
}{if (NF>4){ \
        print $1, $2, $3, ($4/$2), ($5/2), ", " $6, $7, ($8/$6), ($9/$6) \
        } \
}'` >> compareWithDNase.csv

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"