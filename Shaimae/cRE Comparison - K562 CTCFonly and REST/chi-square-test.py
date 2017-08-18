# Author: Shaimae Elhajjajy

# Load necessary packages
import scipy.stats
import numpy as np
from decimal import Decimal

# Python script to find the chi-squared and p-values for CTCF-only +REST or CTCF-only -REST and TFs / Histone Marks

# Open and load all the data files 

with open('./chiSquare-WilcoxData/TFoverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
tfOverlap = [int(value) for value in content]

with open('./chiSquare-WilcoxData/TFnoOverlap.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
tfNoOverlap = [int(value) for value in content]

with open('./chiSquare-WilcoxData/histoneoverlap.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
histoneOverlap = [int(value) for value in content]

with open('./chiSquare-WilcoxData/histonenoOverlap.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
histoneNoOverlap = [int(value) for value in content]

# Open and load all the file information (experiment ID, peak file ID, and TF name)
with open('experimentNamesTF.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
experimentTF = [str(value) for value in content]

with open('peakFileNamesTF.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
peakFileTF = [str(value) for value in content]

with open('targetNamesTF.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
targetTF = [str(value) for value in content]

# Open and load all the file information (experiment ID, peak file ID, and Histone Mark name)
with open('experimentNamesHistone.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
experimentHistone = [str(value) for value in content]

with open('peakFileNamesHistone.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
peakFileHistone = [str(value) for value in content]

with open('targetNamesHistone.txt') as f:
        content = f.readlines()
content=[x.strip() for x in content]
targetHistone = [str(value) for value in content]

# Find the number of CTCF-only cREs that overlap with REST and the number of CTCF-only cREs that do NOT overlap with REST
totalOverlap=13045
totalNoOverlap=4515

# For TFs

count=len(tfOverlap)

for i in range(0, count):
	# Avoid an error message; if both values are zero, the chi-squared test won't work
        if tfOverlap[i] == 0 | tfNoOverlap[i] == 0:
                print " "
                continue
        else:
		# Set up the observed data
                observed = [[tfOverlap[i], tfNoOverlap[i]], [totalOverlap-tfOverlap[i], totalNoOverlap-tfNoOverlap[i]]]
		# Perform the chi-square test using built-in function (contingency table method)
                chi, p, dof, ex = scipy.stats.chi2_contingency(observed) # correction=True
		# Write the results to a file
                f= open("./results/TFchisquare.txt", "a+")
		f.write(experimentTF[i])
                f.write("\t")
                f.write(peakFileTF[i])
                f.write("\t")
                f.write(targetTF[i])
                f.write("\t")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()

# For Histones

count2=len(histoneOverlap)

for j in range(0, count2):
	# Avoid an error message; if both values are zero, the chi-squared test won't work
	if histoneOverlap[j] == 0 | histoneNoOverlap[j] == 0:
		print " "
		continue
	else:
		# Set up the observed data
		observed = [[histoneOverlap[j], histoneNoOverlap[j]], [totalOverlap-histoneOverlap[j], totalNoOverlap-histoneNoOverlap[j]]]
		# Perform the chi-square test using built-in function (contingency table method)
		chi, p, dof, ex = scipy.stats.chi2_contingency(observed) # correction=True
		# Write the results to a file
                f= open("./results/histoneChiSquare.txt", "a+")
		f.write(experimentHistone[j])
                f.write("\t")
                f.write(peakFileHistone[j])
                f.write("\t")
                f.write(targetHistone[j])
                f.write("\t")
                f.write("%.3f" % chi)
                f.write("\t")
                f.write("%.3E" % Decimal(p))
                f.write("\n")
                f.close()
