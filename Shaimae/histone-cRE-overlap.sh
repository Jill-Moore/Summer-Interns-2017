#!/bin/bash
# Author: Shaimae Elhajjajy
# Script that uses bedtools intersect to find the percent overlap between the GM12878 cREs and histone mark ChIP-seq peaks

# Get the ENCODE file information (experiment ID, peak file ID, and histone mark name) from the text file
awk '{print $1}' ./GM12878-Histone.txt > experimentNames.txt
awk '{print $2}' ./GM12878-Histone.txt > peakFileNames.txt
awk '{print $3}' ./GM12878-Histone.txt > targetNames.txt

# Create arrays for each of the three types of file information from above
experiment=( `cat "experimentNames.txt" `)
peakFile=( `cat "peakFileNames.txt" `)
target=( `cat "targetNames.txt" `)

# Create array for the cRE information
cREs=( `cat "GM12878-cRE.txt" `)

# Find the number of histone marks that will be intersected
numberOfHistoneMarks=`cat "targetNames.txt" | wc -l`

# Find the upper limit of the range of the for loop
limit=$(( $numberOfHistoneMarks - 1 ))

# Make new directory to store all the histone mark files
mkdir GM12878HistoneFiles

# Make new directory to store all the results
mkdir GM12878OverlapResults

# Set up the result files with headers 
for k in {0..5}
do
	# Strip the ".bed" extension from the cRE file name
        fileName=`basename ./GM12878cREfiles/${cREs[$k]} .bed`
	# Create the header and write it to each results file
        echo -e Experiment '\t' Peak File '\t' Target '\t' Number of Overlaps '\t' Percent Overlap '\t' >> ./GM12878OverlapResults/$fileName-Overlap.txt
done

for i in $(seq 0 $limit)
do
        # Copy the histone mark file to the current directory
        cp /data/projects/encode/data/${experiment[$i]}/${peakFile[$i]}.bed.gz ./GM12878HistoneFiles/
	# Unzip the file
        gunzip ./GM12878HistoneFiles/${peakFile[$i]}.bed.gz

	# Perform bedtools intersect
        for j in {0..5}
        do
                # Find the number of intersections between the cRE and the histone mark
                numberOfOverlaps=$( bedtools intersect -u -a ./GM12878cREfiles/${cREs[$j]} -b ./GM12878HistoneFiles/${peakFile[$i]}.bed | wc -l )
		# Find the total number of cREs
                totalcREs=$( wc -l ./GM12878cREfiles/${cREs[$j]} | cut -f 1 -d ' ' )
		# Find the percent overlap between the cRE and the histone mark
                percentOverlap=$( awk "BEGIN {printf \"%.2f\", $numberOfOverlaps / $totalcREs * 100 }")
                # Strip the ".bed" extension from the cRE file name
                fileName=`basename ./GM12878cREfiles/${cREs[$j]} .bed`
                # Append the results to the file
                echo -e ${experiment[$i]} '\t' ${peakFile[$i]} '\t' ${target[$i]} '\t' $numberOfOverlaps '\t' $percentOverlap >> ./GM12878OverlapResults/$fileName-Overlap.txt
	done
done

# ----------------

# Contents of GM12878-Histone.txt

# ENCSR000AOV	ENCFF584NAD	H2AFZ
# ENCSR000AKC	ENCFF816AHV	H3K27ac
# ENCSR000DRX	ENCFF851UKZ	H3K27me3
# ENCSR000AKD	ENCFF247VUO	H3K27me3
# ENCSR000DRW	ENCFF479XLN	H3K36me3
# ENCSR000AKF	ENCFF921LKB	H3K4me1
# ENCSR000AKG	ENCFF983SMS	H3K4me2
# ENCSR000AKA	ENCFF795URC	H3K4me3
# ENCSR057BWO	ENCFF295GNH	H3K4me3
# ENCSR000AOW	ENCFF357HZM	H3K79me2
# ENCSR000AKH	ENCFF052MHA	H3K9ac
# ENCSR000AKI	ENCFF308WNH	H4K20me1

# Contents of GM12878-cRE.txt

# GM12878-Promoter.bed
# GM12878-Enhancer.bed
# GM12878-CTCF.bed
# GM12878-DNase-Group1.bed
# GM12878-DNase-Group2.bed
# GM12878-Inactive.bed
