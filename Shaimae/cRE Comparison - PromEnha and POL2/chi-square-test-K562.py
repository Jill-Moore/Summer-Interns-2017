# Author: Shaimae Elhajjajy

# Load necessary packages
import scipy.stats
import numpy as np
from decimal import Decimal

# Python script to find the chi-squared and p-values for Promoter-like/Enhancer-like cREs  +POL2  or Promoter-like/Enhancer-like cREs -POL2 and Histone Marks

# Open and load all the data files 

with open('./chiSquare-WilcoxData/histoneoverlap_Promoter-POL2_K562.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
promoterOverlap = [int(value) for value in content]

with open('./chiSquare-WilcoxData/histonenoOverlap_Promoter-POL2_K562.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
promoterNoOverlap = [int(value) for value in content]

with open('./chiSquare-WilcoxData/histoneoverlap_Enhancer-POL2_K562.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
enhancerOverlap = [int(value) for value in content]

with open('./chiSquare-WilcoxData/histonenoOverlap_Enhancer-POL2_K562.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
enhancerNoOverlap = [int(value) for value in content]

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

# Find the number of Promoter-like/Enhancer-like cREs that overlap with POL2 and the number of Promoter-like/Enhancer-like cREs that do NOT overlap with POL2
total_PPOL2_O=15600
total_PPOL2_N=14490
total_EPOL2_O=5869
total_EPOL2_N=32121

count=len(promoterOverlap)

for i in range(0, count):

	# Avoid an error message; if both values are zero, the chi-squared test won't work
	if promoterOverlap[i] == 0 | promoterNoOverlap[i] == 0:
		print " "
		continue
	else:
		# Set up the observed data
		observed = [[promoterOverlap[i], promoterNoOverlap[i]], [total_PPOL2_O-promoterOverlap[i], total_PPOL2_N-promoterNoOverlap[i]]]
		# Perform the chi-square test using built-in function (contingency table method)
                chi, p, dof, ex = scipy.stats.chi2_contingency(observed) # correction=True
		# Write the results to a file
                f= open("./K562results/promoterChiSquare.txt", "a+")
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

	if enhancerOverlap[i] == 0 | enhancerOverlap[i] == 0:
		print " "
		continue
	else:
		# Set up the observed data
                observed = [[enhancerOverlap[i], enhancerNoOverlap[i]], [total_EPOL2_O-enhancerOverlap[i], total_EPOL2_N-enhancerNoOverlap[i]]]
		# Perform the chi-square test using built-in function (contingency table method)
                chi, p, dof, ex = scipy.stats.chi2_contingency(observed) # correction=True
                # Write the results to a file
                f= open("./K562results/enhancerChiSquare.txt", "a+")
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

