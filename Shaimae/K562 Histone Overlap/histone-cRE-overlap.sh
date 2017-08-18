#!/bin/bash
# Author: Shaimae Elhajjajy
# Script that uses bedtools intersect to find the percent overlap between K562 cREs and histone mark ChIP-seq peaks

# Get the ENCODE file information (experiment ID, peak file ID, and histone mark name) from the text file
awk '{print $1}' ./K562-Histone.txt > experimentNames.txt
awk '{print $2}' ./K562-Histone.txt > peakFileNames.txt
awk '{print $3}' ./K562-Histone.txt > targetNames.txt

# Create arrays for each of the three types of file information from above
experiment=( `cat "experimentNames.txt" `)
peakFile=( `cat "peakFileNames.txt" `)
target=( `cat "targetNames.txt" `)

# Create array for the cRE information
cREs=( `cat "K562-cRE.txt" `)

# Find the number of histone marks that will be intersected
numberOfHistoneMarks=`cat "targetNames.txt" | wc -l`

# Find the upper limit of the range of the for loop
limit=$(( $numberOfHistoneMarks - 1 ))

# Make new directory to store all the histone mark files
mkdir K562HistoneFiles

# Make new directory to store all the results
mkdir K562OverlapResults

# Set up the result files with headers 
for k in {0..5}
do
        # Strip the ".bed" extension from the cRE file name
        fileName=`basename ./K562cREfiles/${cREs[$k]} .bed`
        # Create the header and write it to each results file
        echo -e Experiment '\t' Peak File '\t' Target '\t' Number of Overlaps '\t' Percent Overlap '\t' >> ./K562OverlapResults/$fileName-Overlap.txt
done

# Cycle through each histone mark file and intersect with each cRE to find the percent overlap

for i in $(seq 0 $limit)
do
	# Copy the histone mark file to the current directory
        cp /data/projects/encode/data/${experiment[$i]}/${peakFile[$i]}.bed.gz ./K562HistoneFiles/
	# Unzip the file
        gunzip ./K562HistoneFiles/${peakFile[$i]}.bed.gz
	
	# Perform bedtools intersect 
        for j in {0..5}
        do
		# Find the number of intersections between the cRE and the histone mark
		numberOfOverlaps=$( bedtools intersect -u -a ./K562cREfiles/${cREs[$j]} -b ./K562HistoneFiles/${peakFile[$i]}.bed | wc -l )
		# Find the total number of cREs
		totalcREs=$( wc -l ./K562cREfiles/${cREs[$j]} | cut -f 1 -d ' ' )
		# Find the percent overlap between the cRE and the histone mark
		percentOverlap=$( awk "BEGIN {printf \"%.2f\", $numberOfOverlaps / $totalcREs * 100 }")
                # Strip the ".bed" extension from the cRE file name
                fileName=`basename ./K562cREfiles/${cREs[$j]} .bed`
                # Append the results to the file
                echo -e ${experiment[$i]} '\t' ${peakFile[$i]} '\t' ${target[$i]} '\t' $numberOfOverlaps '\t' $percentOverlap >> ./K562OverlapResults/$fileName-Overlap.txt
	done
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

# Contents of "K562-cRE.txt"

# K562-Promoter.bed
# K562-Enhancer.bed
# K562-CTCF.bed
# K562-DNase-Group1.bed
# K562-DNase-Group2.bed
# K562-Inactive.bed

