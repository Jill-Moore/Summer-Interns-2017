#!/bin/bash
# Script to find the average peak width of the GM12878 and K562 Histone Mark peak files (similar script can be applied to any .bed file to find the average peak width or average cRE length)

# Isolate the columns .bed file names
awk '{print $1}' allHistoneFiles.txt > experimentNames.txt
awk '{print $2}' allHistoneFiles.txt > peakFileNames.txt 
awk '{print $3}' allHistoneFiles.txt > targetNames.txt

# Create an array of all the GM12878 and K562 Histone Mark file names
peakFile=( `cat "./peakFileNames.txt" `)

# Create other arrays
experiment=( `cat "./experimentNames.txt" `)
target=( `cat "./targetNames.txt" `)

# Set up results file with headers
echo -e Experiment '\t' Peak File '\t' Target '\t' Average Peak Width '\t' >> ./avgPeakWidth_Results.txt

# Cycle through all of the files to find the average peak width

for i in {0..30}
do
	# for GM12878 files (listed first in the text file)
	if [ $i -le 11 ]
	then
		# Subtract the start and end columns of the peaks from the .bed file to find the width of each peak
		awk '{print $3-$2}' ~/finalScripts/GM12878-Histone-Overlap/GM12878HistoneFiles/${peakFile[$i]} > peakWidths$i.txt 
	# for K562 files (listed after GM12878 in the text file)
	else 
		# Subtract the start and end columns of the peaks from the .bed file to find the width of each peak
		awk '{print $3-$2}' ~/finalScripts/K562-Histone-Overlap/K562HistoneFiles/${peakFile[$i]} > peakWidths$i.txt
	fi

	# Find the average of all of the peak widths and assign to a variable
        avgWidth=`awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }' peakWidths$i.txt`
        # Send the values to another results file
        echo -e ${experiment[$i]} '\t' ${peakFile[$i]} '\t' ${target[$i]} '\t' $avgWidth >> ./avgPeakWidth_Results.txt
        # Clean up 
        rm peakWidths$i.txt
	
done

# Clean up
rm experimentNames.txt
rm peakFileNames.txt
rm targetNames.txt

# -------------------------------

# Contents of "allHistoneFiles.txt"

# ENCSR000AOV  ENCFF584NAD.bed  H2AFZ
# ENCSR000AKC  ENCFF816AHV.bed  H3K27ac
# ENCSR000DRX  ENCFF851UKZ.bed  H3K27me3
# ENCSR000AKD  ENCFF247VUO.bed  H3K27me3
# ENCSR000DRW  ENCFF479XLN.bed  H3K36me3
# ENCSR000AKF  ENCFF921LKB.bed  H3K4me1
# ENCSR000AKG  ENCFF983SMS.bed  H3K4me2
# ENCSR000AKA  ENCFF795URC.bed  H3K4me3
# ENCSR057BWO  ENCFF295GNH.bed  H3K4me3
# ENCSR000AOW  ENCFF357HZM.bed  H3K79me2
# ENCSR000AKH  ENCFF052MHA.bed  H3K9ac
# ENCSR000AKI  ENCFF308WNH.bed  H4K20me1
# ENCSR000APC  ENCFF624XRN.bed  H2AFZ
# ENCSR000AKP  ENCFF044JNJ.bed  H3K27ac
# ENCSR000EWB  ENCFF126QYP.bed  H3K27me3
# ENCSR000DWC  ENCFF482VSO.bed  H3K27me3
# ENCSR000AKQ  ENCFF322IFF.bed  H3K27me3
# ENCSR000DWB  ENCFF676RWX.bed  H3K36me3
# ENCSR000AKR  ENCFF498CMP.bed  H3K36me3
# ENCSR000AKS  ENCFF183UQD.bed  H3K4me1
# ENCSR000EWC  ENCFF730VTO.bed  H3K4me1
# ENCSR000AKT  ENCFF099LMD.bed  H3K4me2
# ENCSR000AKU  ENCFF127XXD.bed  H3K4me3
# ENCSR668LDD  ENCFF737AMS.bed  H3K4me3
# ENCSR000EWA  ENCFF883POK.bed  H3K4me3
# ENCSR000APD  ENCFF769WZF.bed  H3K79me2
# ENCSR000EVZ  ENCFF695JMF.bed  H3K9ac
# ENCSR000EVZ  ENCFF085JHT.bed  H3K9ac
# ENCSR000AKV  ENCFF173ULG.bed  H3K9ac
# ENCSR000APE  ENCFF894VEM.bed  H3K9me3
# ENCSR000AKX  ENCFF139CKE.bed  H4K20me1