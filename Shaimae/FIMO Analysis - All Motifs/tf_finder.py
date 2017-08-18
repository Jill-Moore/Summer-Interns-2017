# Author: Shaimae Elhajjajy
# Script to find the number of unique peaks which contain a certain TF, for each TF

# referenceTFs.txt --> list of all possible TFs present in the CisBP-TF.meme file, used in FIMO
with open('referenceTFs.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
referenceTFs = [str(value) for value in content]

# listOfTFs_filtered.txt --> list of all TFs from the fimo.txt file (column 1)
with open('listOfTFs_filtered.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
listOfTFs = [str(value) for value in content]

# listOfPeaks_filtered.txt --> list of all peaks from the fimo.txt file (column 2)
with open('listOfPeaks_filtered.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
listOfPeaks = [str(value) for value in content]

count=len(listOfPeaks)

for i in range(0, 624):
	for j in range(0, count):
		if referenceTFs[i] == listOfTFs[j]:
			f= open("results" + str(i) + ".txt", "a+")
			f.write(referenceTFs[i])
			f.write("\t")
			f.write(listOfPeaks[j])
			f.write("\n")
			f.close()
