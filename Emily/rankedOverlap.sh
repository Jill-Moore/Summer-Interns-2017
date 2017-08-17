#!/bin/bash
#Emily Earl 6/23/17 redone 7/10/17
#rankedOverlap
#This script will sort the ATAC-seq peaks with the highest P values first. Then
# it will look at 5000 peaks at a time and see what percentage of the 5000 peaks
# overlap with the cREs. Also records the raw numbers out of 5000 in a temp file.
#NO arguments. Will draw from a text file with the names of the files

START=$(date +%s)
cREs="/data/projects/rusers/Emily-2017/mm10-cREs.bed"
FileList="/data/projects/rusers/Emily-2017/File-List.txt"
fileNum=`cat $FileList | wc -l`

echo "Description, DataSet, `echo {5000..100000..5000},`" > rankedOverlap.csv

for outerInd in {1..27}
do
        file=`cat $FileList | head -$outerInd | tail -1 | cut -c-11`
        description=`cat $FileList | head -$outerInd | tail -1 | cut -f 2`
        fileName="/data/projects/rusers/Emily-2017/$file.bed"
        cat $fileName | sort -k8,8rg > ~/tempHelper/workingInfo #sort by P-value, highest first
        echo > ~/tempHelper/numerators #this file will help get around integer division

        echo $description > ~/tempHelper/numerators
        echo $file >> ~/tempHelper/numerators

        for index in {5000..100000..5000}
        do
                head -$index ~/tempHelper/workingInfo | tail -5000 > ~/tempHelper/subset
        echo $index: `bedtools intersect -u -a ~/tempHelper/subset -b $cREs | wc -l` >> ~/tempHelper/numerators
        done

        cat ~/tempHelper/numerators | awk 'BEGIN{FS=": "; \
        ORS=", "} 
        {if(NF==1) \
                {print $1} \
        else{ \
                print ($2/5000) \
        } \
        }       
        END{ ORS=""; \
        print "\n"}' >> rankedOverlap.csv

        echo $outerInd
done

END=$(date +%s)
DIFF=$(( $END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"