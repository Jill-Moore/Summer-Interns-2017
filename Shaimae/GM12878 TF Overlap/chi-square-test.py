# Author: Shaimae Elhajjajy

# Load necessary packages
import scipy.stats
import numpy as np
from decimal import Decimal

# Python script to find chi square values for GM12878 cRE-TF overlaps; goal is to look for any DNase Group 2 enrichment in TFs.

# Open and load all the data files (which are the results of the bedtools intersect GM12878 cRE-TF overlaps)
with open('./chiSquareData/DNase2Overlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
DNase2 = [int(value) for value in content]

with open('./chiSquareData/promoterOverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
Promoter = [int(value) for value in content]

with open('./chiSquareData/enhancerOverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
Enhancer = [int(value) for value in content]

with open('./chiSquareData/CTCFOverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
CTCF = [int(value) for value in content]

with open('./chiSquareData/DNase1Overlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
DNase1 = [int(value) for value in content]

with open('./chiSquareData/inactiveOverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
Inactive = [int(value) for value in content]

# Open and load all the file information (experiment ID, peak file ID, and TF name)
with open('experimentNames.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
experiment = [str(value) for value in content]

with open('peakFileNames.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
peakFile = [str(value) for value in content]

with open('targetNames.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
target = [str(value) for value in content]

# Find the number of TFs there are (this number will be used as the range in the for loop)
numberOfTFs=len(DNase2)

# Find the total number of cREs, for each type
totalPromoter=36022
totalEnhancer=27739
totalCTCF=10913
totalDNase1=16085
totalDNase2=1203
totalInactive=1219393

for i in range(0, numberOfTFs):
	
#DNase2 - Promoter

	# Avoid an error message; if both values are zero, the chi-squared test won't work
	if DNase2[i] == 0 | Promoter[i] == 0: 
		print " "
		continue
	else:
		# Set up the observed data: number of DNase2 overlap, number of Promoter overlap, number of DNase2 that doesn't overlap, number of Promoter that doesn't overlap
		observed = [[DNase2[i], Promoter[i]], [totalDNase2-DNase2[i], totalPromoter-Promoter[i]]]
		# Perform the chi-square test using built-in function (contingency table method)
		chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		# Write the results to a file
		f= open("./chiSquareResults/DNase2-Promoter-chisq.txt", "a+")
		f.write(experiment[i])
		f.write("\t")
		f.write(peakFile[i])
		f.write("\t")
		f.write(target[i])
		f.write("\t")
		f.write("%.3f" % chi)
		f.write("\t")
		f.write("%.3E" % Decimal(p))
		f.write("\n")
		f.close()

#DNase2 - Enhancer

	if DNase2[i] == 0 | Enhancer[i] == 0:
        	print " "
                continue
        else:
                observed = [[DNase2[i], Enhancer[i]], [totalDNase2-DNase2[i], totalEnhancer-Enhancer[i]]]
	        chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		f= open("./chiSquareResults/DNase2-Enhancer-chisq.txt", "a+")
                f.write(experiment[i])
                f.write("\t")
                f.write(peakFile[i])
                f.write("\t")
                f.write(target[i])
                f.write("\t")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()

#DNase2 - CTCF

	if DNase2[i] == 0 | CTCF[i] == 0:
        	print " "
                continue
        else:
       	        observed = [[DNase2[i], CTCF[i]], [totalDNase2-DNase2[i], totalCTCF-CTCF[i]]]
	        chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		f= open("./chiSquareResults/DNase2-CTCF-chisq.txt", "a+")
                f.write(experiment[i])
                f.write("\t")
                f.write(peakFile[i])
                f.write("\t")
                f.write(target[i])
                f.write("\t")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()

#DNase2 - DNase1

	if DNase2[i] == 0 | DNase1[i] == 0:
        	print " "
                continue
        else:
                observed = [[DNase2[i], DNase1[i]], [totalDNase2-DNase2[i], totalDNase1-DNase1[i]]]
	        chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		f= open("./chiSquareResults/DNase2-DNase1-chisq.txt", "a+")
                f.write(experiment[i])
                f.write("\t")
                f.write(peakFile[i])
                f.write("\t")
                f.write(target[i])
                f.write("\t")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()        

#DNase2 - Inactive

	if DNase2[i] == 0 | Inactive[i] == 0:
        	print " "
                continue
        else:
                observed = [[DNase2[i], Inactive[i]], [totalDNase2-DNase2[i], totalInactive-Inactive[i]]]
	        chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		f= open("./chiSquareResults/DNase2-Inactive-chisq.txt", "a+")
                f.write(experiment[i])
                f.write("\t")
                f.write(peakFile[i])
                f.write("\t")
                f.write(target[i])
                f.write("\t")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()
