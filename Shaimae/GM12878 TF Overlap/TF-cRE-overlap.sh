#!/bin/bash
# Author: Shaimae Elhajjajy
# Script that uses bedtools intersect to find the percent overlap between GM12878 cREs and TF ChIP-seq peaks

# Get ENCODE file information (experiment ID, peak file ID, TF name) from the file
awk '{print $1}' ./GM12878-TF.txt > experimentNames.txt
awk '{print $2}' ./GM12878-TF.txt > peakFileNames.txt
awk '{print $3}' ./GM12878-TF.txt > targetNames.txt

# Create arrays for each of the three types of file information from above
experiment=( `cat "experimentNames.txt" `)
peakFile=( `cat "peakFileNames.txt" `)
target=( `cat "targetNames.txt" `)

# Create array for the cRE information
cREs=( `cat "GM12878-cRE.txt" `)

# Find the number of TFs that will be intersected
numberOfTFs=`cat "targetNames.txt" | wc -l`

# Find the upper limit of the range of the for loop
limit=$(( $numberOfTFs - 1 ))

# Make new directory to store all the TF files
mkdir GM12878TFfiles

# Make new directory to store all the results
mkdir GM12878OverlapResults

# Set up the results files with headers 
for k in {0..5}
do
	# Strip the ".bed" extension from the cRE file name
        fileName=`basename ./GM12768cREfiles/${cREs[$k]} .bed`
	# Create the header and write it to each results file
        echo -e Experiment '\t' Peak File '\t' Target '\t' Number of Overlaps '\t' Percent Overlap '\t' >> ./GM12878OverlapResults/$fileName-Overlap.txt
done

# Cycle through each TF file and intersect with each cRE to find the percent overlap

for i in $(seq 0 $limit)
do
	# Copy the TF file to the current directory
        cp /data/projects/encode/data/${experiment[$i]}/${peakFile[$i]}.bed.gz ./GM12878TFfiles
	# Unzip the file
	gunzip ./GM12878TFfiles/${peakFile[$i]}.bed.gz
	
	# Perform bedtools intersect 
	for j in {0..5}
	do
		# Find the number of intersections between the cRE and the TF
                numberOfOverlaps=$( bedtools intersect -u -a ./GM12878cREfiles/${cREs[$j]} -b ./GM12878TFfiles/${peakFile[$i]}.bed | wc -l )
		# Find the total number of cREs
		totalcREs=$( wc -l ./GM12878cREfiles/${cREs[$j]} | cut -f 1 -d ' ' )
		# Find the percent overlap between the cRE and the TF
		percentOverlap=$( awk "BEGIN {printf \"%.2f\", $numberOfOverlaps / $totalcREs * 100 }")
                # Strip the ".bed" extension from the cRE file name
                fileName=`basename ./GM12878cREfiles/${cREs[$j]} .bed`
		# Append the results to the file
                echo -e ${experiment[$i]} '\t' ${peakFile[$i]} '\t' ${target[$i]} '\t' $numberOfOverlaps '\t' $percentOverlap >> ./GM12878OverlapResults/$fileName-Overlap.txt
	done
done

# ----------------------

# Contents of "GM12878-TF.txt"

# ENCSR849WCQ	ENCFF917CXD	ASH2L
# ENCSR961PPA	ENCFF127GYQ	ATF2
# ENCSR342THD	ENCFF015YHT	BCLAF1
# ENCSR469WII	ENCFF809PXE	BMI1
# ENCSR860UHK	ENCFF788LSH	CBFB
# ENCSR549NPZ	ENCFF141LEI	CBX3
# ENCSR372GIN	ENCFF420YHY	CBX5
# ENCSR681NOM	ENCFF761MGJ	CEBPB
# ENCSR228DTL	ENCFF934VGQ	CHD1
# ENCSR751CJG	ENCFF499ZPP	CHD4
# ENCSR649WUM	ENCFF861BOG	CHD7
# ENCSR839XZU	ENCFF534CKB	CREM
# ENCSR000AKB	ENCFF833FTF	CTCF
# ENCSR000DRZ	ENCFF002DCM	CTCF
# ENCSR000DRZ	ENCFF473RXY	CTCF
# ENCSR509FWH	ENCFF349MPF	DPF2
# ENCSR199WXF	ENCFF242VUO	EED
# ENCSR597VGC	ENCFF304WER	ETV6
# ENCSR626VUC	ENCFF692GBM	ETV6
# ENCSR000ARD	ENCFF678JII	EZH2
# ENCSR861JUQ	ENCFF980KSV	FOXK2
# ENCSR000BGC	ENCFF617GBZ	GABPA
# ENCSR331HPA	ENCFF116EXQ	GABPA
# ENCSR828NCB	ENCFF456YII	GATAD2B
# ENCSR514VAY	ENCFF895YBG	HCFC1
# ENCSR145XQO	ENCFF935HIG	HDGF
# ENCSR874AFU	ENCFF229YSW	IKZF1
# ENCSR680UQE	ENCFF339FFC	IKZF2
# ENCSR408JQO	ENCFF976ZVG	IRF3
# ENCSR976TBC	ENCFF100ERQ	IRF5
# ENCSR897MMC	ENCFF939TZS	JUNB
# ENCSR000DYS	ENCFF556PIY	JUND
# ENCSR391IWM	ENCFF996RRT	KDM1A
# ENCSR982FSK	ENCFF070LPO	KDM5A
# ENCSR000DYV	ENCFF689AXJ	MAFK
# ENCSR552XSN	ENCFF881VZH	MLLT1
# ENCSR293QAR	ENCFF966RPL	MTA2
# ENCSR278SQL	ENCFF055NJR	NBN
# ENCSR746XEG	ENCFF166FRO	NFXL1
# ENCSR514VYD	ENCFF810CEL	NR2F1
# ENCSR711XNY	ENCFF020GMZ	PKNOX1
# ENCSR000BGD	ENCFF120VUT	POLR2A
# ENCSR482TWQ	ENCFF445UJF	RAD51
# ENCSR330EXS	ENCFF814CZI	RBBP5
# ENCSR387QUV	ENCFF456FQB	RELB
# ENCSR000BGF	ENCFF048JKT	REST
# ENCSR251OVJ	ENCFF711TMS	SMAD5
# ENCSR000BGE	ENCFF199WGD	SRF
# ENCSR332EYT	ENCFF557HJB	STAT1
# ENCSR016UEH	ENCFF374HJR	TARDBP
# ENCSR412QBS	ENCFF733UTZ	TARDBP
# ENCSR739IHN	ENCFF405NFV	TBX21
# ENCSR501DKS	ENCFF305ICK	TCF7
# ENCSR637QAM	ENCFF735XQT	TRIM22
# ENCSR835XKS	ENCFF899JBI	TRIM22
# ENCSR459FTB	ENCFF745TNJ	UBTF
# ENCSR000BGI	ENCFF805GKD	USF1
# ENCSR410HFN	ENCFF756HVY	WHSC1
# ENCSR205SKQ	ENCFF344OJI	YBX1
# ENCSR207PFI	ENCFF123WEZ	ZBED1
# ENCSR189YYK	ENCFF357WYN	ZBTB40
# ENCSR117KWH	ENCFF273BVT	ZNF207
# ENCSR412YGM	ENCFF455HXN	ZSCAN29

# Contents of "GM12878-cRE.txt"

# GM12878-Promoter.bed
# GM12878-Enhancer.bed
# GM12878-CTCF.bed
# GM12878-DNase-Group1.bed
# GM12878-DNase-Group2.bed
# GM12878-Inactive.bed

