# Author: Shaimae Elhajjajy
# Script to find the number of unique peaks which contain a certain motif, for each motif

# referenceMotifs.txt --> list of all possible motifs present in the CisBP-TF.meme file, used in FIMO
with open('referenceMotifs.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
referenceMotifs = [str(value) for value in content]

# listOfMotifs_filtered.txt --> list of all motifs from the fimo.txt file (column 1)
with open('listOfMotifs_filtered.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
listOfMotifs = [str(value) for value in content]

# listOfPeaks_filtered.txt --> list of all peaks from the fimo.txt file (column 2)
with open('listOfPeaks_filtered.txt') as f:
	content = f.readlines()
content=[x.strip() for x in content]
listOfPeaks = [str(value) for value in content]

count=len(listOfPeaks)

for i in range(0, 1741):
	for j in range(0, count):
		if referenceMotifs[i] == listOfMotifs[j]:
			f= open("results" + str(i) + ".txt", "a+")
			f.write(referenceMotifs[i])
			f.write("\t")
			f.write(listOfPeaks[j])
			f.write("\n")
			f.close()
