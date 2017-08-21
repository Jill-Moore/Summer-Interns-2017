#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Tool:  cistrome-overlap"
    echo "Usage: ./cistrome-overlap cistrome-id-file peak-folder cRE-file"
    exit 1
fi

if [ $# != 3 ]
then
    echo "Error: incorrect number of arguments."
    exit 1
fi

cistromefile=$1
peakfolder=$2
crefile=$3

if ! [ -e $cistromefile ] || ! [ -e $peakfolder ] || ! [ -d $peakfolder ] || ! [ -e $crefile ]
then
    echo "Error: some files/folders do not exist."
    exit 1
fi

if ! [ -e overlap.txt ]
then
    touch overlap.txt
else
    echo "Terminating: overlap.txt already exists."
    exit 1
fi

root=$peakfolder/
while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8
do
    # Calculate number of peaks
    p=$( cat $root$f8 | wc -l )
    
    # Calculate the number of overlapping peaks
    o=$( bedtools intersect -u -a $root$f8 -b $crefile | wc -l )
    
    # Calculate percent overlap
    c=$( echo "scale=4; $o/$p" | bc )

    echo "$f1;$f7;$f4;$f5;$f6;$p;$o;$c"
    echo "$f1;$f7;$f4;$f5;$f6;$p;$o;$c" >> overlap.txt

done < $cistromefile
