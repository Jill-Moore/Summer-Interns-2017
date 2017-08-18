#!/bin/bash
# Author: Shaimae Elhajjajy
# Script to find the overlaps between histone marks and regions of K562 CTCF-only cREs that overlap with REST peaks

# Prompt the user to enter the name of the file for histone mark overlapping analysis
if [ $# != 1 ]
then
        echo Enter the name of the file for which you want to perform the histone mark overlap.
        exit
fi

# Get ENCODE file information (experiment ID, peak file ID, histone mark name) from the text file
awk '{print $1}' ./K562-Histone.txt > experimentNamesHistone.txt
awk '{print $2}' ./K562-Histone.txt > peakFileNamesHistone.txt
awk '{print $3}' ./K562-Histone.txt > targetNamesHistone.txt

# Create arrays for each of the three types of file information from above
experiment=( `cat "experimentNamesHistone.txt" `)
peakFile=( `cat "peakFileNamesHistone.txt" `)
target=( `cat "targetNamesHistone.txt" `)

# Strip the ".bed" extension from the cRE file name
fileName=`basename $1 .bed`

# Set up the header of the results file
echo -e Experiment '\t' Peak File '\t' Target '\t' \# Overlaps '\t' Percent Overlap >> ./results/histone$fileName.txt

# Find the number of histone marks that will be intersected
numberOfHistoneMarks=`cat "targetNamesHistone.txt" | wc -l`

# Find the upper limit of the range of the for loop
limit=$(( $numberOfHistoneMarks - 1 ))

# Cycle through each histone mark file and intersect with each cRE to find the percent overlap

for i in $(seq 0 $limit)
do
	# Find the number of intersections between the CTCF-only cREs that overlap with REST peaks and the histone marks
        numberOfOverlaps=$( bedtools intersect -u -a ./$1 -b ../K562-Histone-Overlap/K562HistoneFiles/${peakFile[$i]}.bed | wc -l )
	# Find the total number of CTCF-only cREs that overlap with REST peaks
        totalcREs=$( wc -l ./$1 | cut -f 1 -d ' ')
        # Calculate the percent overlap between the cREs and the histone marks
        percentOverlap=$(awk "BEGIN {printf \"%.2f\", $numberOfOverlaps / $totalcREs * 100 }")	

	echo -e ${experiment[$i]} '\t' ${peakFile[$i]} '\t' ${target[$i]} '\t' $numberOfOverlaps '\t' $percentOverlap >> ./results/histone$fileName.txt

done

# -------------

# Contents of "K562-Histone.txt"

# ENCSR000APC	ENCFF624XRN	H2AFZ
# ENCSR000AKP	ENCFF044JNJ	H3K27ac
# ENCSR000EWB	ENCFF126QYP	H3K27me3
# ENCSR000DWC	ENCFF482VSO	H3K27me3
# ENCSR000AKQ	ENCFF322IFF	H3K27me3
# ENCSR000DWB	ENCFF676RWX	H3K36me3
# ENCSR000AKR	ENCFF498CMP	H3K36me3
# ENCSR000AKS	ENCFF183UQD	H3K4me1
# ENCSR000EWC	ENCFF730VTO	H3K4me1
# ENCSR000AKT	ENCFF099LMD	H3K4me2
# ENCSR000AKU	ENCFF127XXD	H3K4me3
# ENCSR668LDD	ENCFF737AMS	H3K4me3
# ENCSR000EWA	ENCFF883POK	H3K4me3
# ENCSR000APD	ENCFF769WZF	H3K79me2
# ENCSR000EVZ	ENCFF695JMF	H3K9ac
# ENCSR000EVZ	ENCFF085JHT	H3K9ac
# ENCSR000AKV	ENCFF173ULG	H3K9ac
# ENCSR000APE	ENCFF894VEM	H3K9me3
# ENCSR000AKX	ENCFF139CKE	H4K20me1
