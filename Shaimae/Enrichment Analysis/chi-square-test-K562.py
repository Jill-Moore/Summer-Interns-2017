# Author: Shaimae Elhajjajy

# Load necessary packages
import scipy.stats
import numpy as np
from decimal import Decimal

# Python script to find chi square values for one category in comparison to the other 4 (inactive not included) 

# Open and load all the data files (which are the results of the bedtools intersect K562 cRE-TF overlaps)
with open('DNase2Overlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
DNase2 = [int(value) for value in content]

with open('promoterOverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
Promoter = [int(value) for value in content]

with open('enhancerOverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
Enhancer = [int(value) for value in content]

with open('CTCFOverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
CTCF = [int(value) for value in content]

with open('DNase1Overlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
DNase1 = [int(value) for value in content]

with open('otherThanP.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
otherThanP = [int(value) for value in content]

with open('otherThanE.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
otherThanE = [int(value) for value in content]

with open('otherThanCTCF.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
otherThanCTCF = [int(value) for value in content]

with open('otherThanDNaseG1.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
otherThanD1 = [int(value) for value in content]

with open('otherThanDNaseG2.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
otherThanD2 = [int(value) for value in content]

# Find the number of TFs there are (this number will be used as the range in the for loop)
numberOfTFs=len(DNase2)

# Find the total number of cREs, for each type
TotalDNase2=6293
TotalPromoter=30090
TotalEnhancer=37990
TotalCTCF=17560
TotalDNase1=40553
TotalOtherThanP=102396
TotalOtherThanE=94496
TotalOtherThanCTCF=114926
TotalOtherThanD1=91933
TotalOtherThanD2=126193

for i in range(0, numberOfTFs):

	# Avoid an error message; if both values are zero, the chi-squared test won't work
	if Promoter[i] == 0 | otherThanP[i] == 0: 
		print " "
		continue
	else:
		# Set up the observed data
		observed = [[Promoter[i], otherThanP[i]], [TotalPromoter-Promoter[i], TotalOtherThanP-otherThanP[i]]]
		# Perform the chi-square test using built-in function (contingency table method)
		chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		# Write the results to a file
                f= open("./chiSquareResults/promoter_K562.txt", "a+")
		f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()

	if Enhancer[i] == 0 | otherThanE[i] == 0:
        	print " "
                continue
        else:
                observed = [[Enhancer[i], otherThanE[i]], [TotalEnhancer-Enhancer[i], TotalOtherThanE-otherThanE[i]]]
	        chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		f= open("./chiSquareResults/enhancer_K562.txt", "a+")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()

	if CTCF[i] == 0 | otherThanCTCF[i] == 0:
        	print " "
                continue
        else:
       	        observed = [[CTCF[i], otherThanCTCF[i]], [TotalCTCF-CTCF[i], TotalOtherThanCTCF-otherThanCTCF[i]]]
	        chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		f= open("./chiSquareResults/CTCF_K562.txt", "a+")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()

	if DNase1[i] == 0 | otherThanD1[i] == 0:
        	print " "
                continue
        else:
                observed = [[DNase1[i], otherThanD1[i]], [TotalDNase1-DNase1[i], TotalOtherThanD1-otherThanD1[i]]]
	        chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		f= open("./chiSquareResults/DNaseGroup1_K562.txt", "a+")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()        

	if DNase2[i] == 0 | otherThanD2[i] == 0:
        	print " "
                continue
        else:
                observed = [[DNase2[i], otherThanD2[i]], [TotalDNase2-DNase2[i], TotalOtherThanD2-otherThanD2[i]]]
	        chi, p, dof, ex = scipy.stats.chi2_contingency(observed)  # correction=True
		f= open("./chiSquareResults/DNaseGroup2_K562.txt", "a+")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()
