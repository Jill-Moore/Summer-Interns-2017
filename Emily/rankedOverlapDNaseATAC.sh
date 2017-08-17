#!/bin/bash
#Emily Earl 7/7/17
#rankedOverlapDNaseATAC (previously compareDNaseATAC)
#Make 2 files: ATACwithDNase which is percent of ATAC-seq peaks overlapping with DNase peaks
#              DNasewithATAc which is percent of DNase peaks overlapping with ATAC-seq peaks
#Uses quite a few temp folders to organize. The temp things will be in ~/tempHelper/compareDNaseATAC
#No arguments, will draw from Data-List.txt

START=$(date +%s)

path="/data/projects/rusers/Emily-2017/DNase-ATAC-Comparison"
list="$path/Data-List.txt"

echo "Tissue-Timepoint, ATAC-seq, DNase, `echo {5000..100000..5000},`" > ATACwithDNase.csv
echo "Tissue_Timepoint, ATAC-seq, DNase, `echo {5000..100000..5000},`" > DNasewithATAC.csv

for outerInd in {2..13}
do
        description=`cat $list | head -$outerInd | tail -1 | cut -f 1`
        ATAC=`cat $list | head -$outerInd | tail -1 | cut -f 2`
        DNase=`cat $list | head -$outerInd | tail -1 | cut -f 3`

        echo > ~/tempHelper/compareDNaseATAC/DNaseNum
        echo > ~/tempHelper/compareDNaseATAC/ATACNum

        echo $description > ~/tempHelper/compareDNaseATAC/DNaseNum
        echo $ATAC >> ~/tempHelper/compareDNaseATAC/DNaseNum
        echo $DNase >> ~/tempHelper/compareDNaseATAC/DNaseNum

        echo $description > ~/tempHelper/compareDNaseATAC/ATACNum
        echo $ATAC >> ~/tempHelper/compareDNaseATAC/ATACNum
        echo $DNase >> ~/tempHelper/compareDNaseATAC/ATACNum

        ATAC="$path/$ATAC.bed"
        DNase="$path/$DNase.Mod.bed"
		
		cat $ATAC | sort -k8,8rg > ~/tempHelper/compareDNaseATAC/sortedATAC
        cat $DNase | sort -k7,7rg > ~/tempHelper/compareDNaseATAC/sortedDNase

        #first intersect ATAC with DNase
        for index in {5000..100000..5000}
        do
                head -$index ~/tempHelper/compareDNaseATAC/sortedATAC | tail -5000 > ~/tempHelper/compareDNaseATAC/ATACsubset
                echo $index: `bedtools intersect -u -a ~/tempHelper/compareDNaseATAC/ATACsubset -b $DNase | wc -l `>> ~/tempHelper/compareDNaseATAC/ATACNum

                head -$index ~/tempHelper/compareDNaseATAC/sortedDNase | tail -5000 > ~/tempHelper/compareDNaseATAC/DNasesubset
                echo $index: `bedtools intersect -u -a ~/tempHelper/compareDNaseATAC/DNasesubset -b $ATAC | wc -l` >> ~/tempHelper/compareDNaseATAC/DNaseNum

        done

#divide for ATAC
        cat ~/tempHelper/compareDNaseATAC/ATACNum | awk 'BEGIN{FS=": "; \
        ORS=", "} \
        {if(NF==1) \
                {print $1} \
        else{ \
        print ($2/5000) \
        } \
        }       \
        END{ ORS=""; \
        print "\n"}' >> ATACwithDNase.csv

#divide for DNase
        cat ~/tempHelper/compareDNaseATAC/DNaseNum | awk 'BEGIN{FS=": "; \
        ORS=", "} \
        {if(NF==1) \
                {print $1} \
        else{ \
                print ($2/5000) \
        } \
        }       \
        END{ ORS=""; \
        print "\n"}' >> DNasewithATAC.csv

echo Done with $outerInd
done

END=$(date +%s)
DIFF=$(($END - $START ))
echo "It took $DIFF seconds to do this script"
MINS=$(($DIFF / 60))
echo "It took $MINS minutes to do this script"   