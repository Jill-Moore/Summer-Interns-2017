#!/bin/bash
# Script to calculate the overlap coefficient for the matrix of K562 and GM12878 Histone Mark files --> the file entered on the command line is constant (file "A") and the overlap coefficient will be calculated for the overlap of A with each of the other files (including itself)

# Prompt the user to enter the name of the histone file
if [ $# != 1 ]
then
        echo Please enter the ENCODE ID of the histone file \(without the .bed extension\).
        exit
fi

# Isolate the columns .bed file names
awk '{print $2}' allHistoneFiles.txt > peakFileNames.txt

# Create an array of all the GM12878 and K562 Histone Mark file names
peakFile=( `cat "./peakFileNames.txt" `)

# Cycle through all the combinations of file pairs and calculate the overlap coefficient
# Note: here, denominator of the overlap coefficient is the number of lines in the smallest file of the overlap

for i in {0..30}
do
	# Find the number of lines in file A
	numLinesA=$(wc -l ./histoneFiles/$1.bed | cut -f 1 -d ' ')
	
	# Find the number of overlaps between files A and B
	numOverlap=$(bedtools intersect -u -a ./histoneFiles/$1.bed -b ./histoneFiles/${peakFile[$i]}.bed | wc -l)
	# Find the number of lines in file B
	numLinesB=$(wc -l ./histoneFiles/${peakFile[$i]}.bed | cut -f 1 -d ' ')
	
	# Find the file with the minimum number of lines
	if [ $numLinesA -lt $numLinesB ]
	then
		# Set variable for minimum number of lines
		minimumLines=$numLinesA
	else
		# Set variable for minimum number of lines
                minimumLines=$numLinesB
        fi
	
	# Calculate the overlap coefficient
        overlapCoeff=$( awk "BEGIN {printf \"%.3f\", $numOverlap / $minimumLines } ")
        echo $overlapCoeff
done

# Clean up
rm peakFileNames.txt

# ------------------

# Contents of "allHistoneFiles.txt"

# ENCSR000AOV  ENCFF584NAD  H2AFZ
# ENCSR000AKC  ENCFF816AHV  H3K27ac
# ENCSR000DRX  ENCFF851UKZ  H3K27me3
# ENCSR000AKD  ENCFF247VUO  H3K27me3
# ENCSR000DRW  ENCFF479XLN  H3K36me3
# ENCSR000AKF  ENCFF921LKB  H3K4me1
# ENCSR000AKG  ENCFF983SMS  H3K4me2
# ENCSR000AKA  ENCFF795URC  H3K4me3
# ENCSR057BWO  ENCFF295GNH  H3K4me3
# ENCSR000AOW  ENCFF357HZM  H3K79me2
# ENCSR000AKH  ENCFF052MHA  H3K9ac
# ENCSR000AKI  ENCFF308WNH  H4K20me1
# ENCSR000APC  ENCFF624XRN  H2AFZ
# ENCSR000AKP  ENCFF044JNJ  H3K27ac
# ENCSR000EWB  ENCFF126QYP  H3K27me3
# ENCSR000DWC  ENCFF482VSO  H3K27me3
# ENCSR000AKQ  ENCFF322IFF  H3K27me3
# ENCSR000DWB  ENCFF676RWX  H3K36me3
# ENCSR000AKR  ENCFF498CMP  H3K36me3
# ENCSR000AKS  ENCFF183UQD  H3K4me1
# ENCSR000EWC  ENCFF730VTO  H3K4me1
# ENCSR000AKT  ENCFF099LMD  H3K4me2
# ENCSR000AKU  ENCFF127XXD  H3K4me3
# ENCSR668LDD  ENCFF737AMS  H3K4me3
# ENCSR000EWA  ENCFF883POK  H3K4me3
# ENCSR000APD  ENCFF769WZF  H3K79me2
# ENCSR000EVZ  ENCFF695JMF  H3K9ac
# ENCSR000EVZ  ENCFF085JHT  H3K9ac
# ENCSR000AKV  ENCFF173ULG  H3K9ac
# ENCSR000APE  ENCFF894VEM  H3K9me3
# ENCSR000AKX  ENCFF139CKE  H4K20me1
