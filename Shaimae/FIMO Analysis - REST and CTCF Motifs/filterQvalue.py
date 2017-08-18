# Author: Shaimae Elhajjajy
# Script to find all of the lines in fimo.txt that have a q-value less than 0.05

# Open the data files
with open('listOfPeaks.txt') as f:
       content = f.readlines()
content=[x.strip() for x in content]
listOfPeaks = [str(value) for value in content]

with open('qvalues.txt') as f:
       content = f.readlines()
content=[x.strip() for x in content]
qvalues = [str(value) for value in content]

# Cycle through the file and filter accordingly

for i in range(0, len(qvalues)):
	# Set constraint for q-value less than 0.05
	if float(qvalues[i]) < 0.05:
		# Write results to a file
        	f= open("fimo_filtered.txt", "a+")
                f.write(listOfPeaks[i])
                f.write("\t")
                f.write(qvalues[i])
                f.write("\n")
                f.close()
