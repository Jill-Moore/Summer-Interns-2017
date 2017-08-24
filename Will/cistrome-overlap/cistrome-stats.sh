#!/bin/bash
# cistrome-stats
# Author: Will Zhang

if [ $# -eq 0 ]
then
    echo "Tool:    cistrome-stats"
    echo "Summary: print table of cistrome overlap statistics (number of peaks, percent of peak overlap, width of peaks, FDR of peaks) both mean and standard deviation given an input file"
    echo "         (generated by cistrome-overlap.sh)"
    echo "Usage:   ./cistrome-stats.sh input-file cistrome-id-file peak-folder"
    exit 1
fi

if [ $# -ne 3 ]
then
    echo "Error: incorrect number of arguments given."
    exit 1
fi

inputfile=$1
cistromefile=$2
peakfolder=$3

if ! [ -e $inputfile ] || ! [ -e $cistromefile ] || ! [ -e $peakfolder ] || ! [ -d $peakfolder ]
then
    echo "Error: some files/folders do not exist."
    exit 1
fi

# Sort the overlap file by name (histone mark, TF, etc).
sort -k2,2 -t';' $inputfile -o tmp-overlap.dat

# Sort the cistrome file by name (histone mark, TF, etc).
sort -k7,7 -t$'\t' $cistromefile -o tmp-cistrome.dat

name="N/A"
nsum=0
nsumsq=0
n=0
psum=0
psumsq=0
p=0

while IFS=';' read f1 f2 f3 f4 f5 f6 f7 f8
do
    if [[ $name == "N/A" ]] 
    then
        name=$f2
    fi

    if [[ $name != $f2 ]]
    then
	nmean=$( echo "scale=3; $nsum/$n" | bc )
        pmean=$( echo "scale=5; $psum/$p" | bc )

        if [ $n -lt 2 ]
        then
            nstdev="N/A"
        else
            nstdev=$( echo "scale=3; sqrt((1/($n-1))*($nsumsq-(($nsum^2)/$n)))" | bc )
        fi

        if [ $p -lt 2 ]
        then
            pstdev="N/A"
        else
            pstdev=$( echo "scale=5; sqrt((1/($p-1))*($psumsq-(($psum^2)/$p)))" | bc )
        fi

        echo "$name;$nmean;$nstdev;$pmean;$pstdev;" >> tmp-num-per.dat

        nsum=0
        nsumsq=0
        n=0
        psum=0
        psumsq=0
        p=0
        name=$f2
    fi

    n=$(( n + 1 ))
    nsum=$( echo "scale=3; $nsum + $f6" | bc )
    nsumsq=$( echo "scale=3; $nsumsq + $f6^2" | bc )
    p=$(( p + 1 ))
    psum=$( echo "scale=5; $psum + $f8" | bc )
    psumsq=$( echo "scale=5; $psumsq + $f8^2" | bc )

done < tmp-overlap.dat

nmean=$( echo "scale=3; $nsum/$n" | bc )
pmean=$( echo "scale=5; $psum/$p" | bc )
    
if [ $n -lt 2 ]
then
    nstdev="N/A"
else
    nstdev=$( echo "scale=5; sqrt((1/($n-1))*($nsumsq-(($nsum^2)/$n)))" | bc )
fi

if [ $p -lt 2 ]
then
    pstdev="N/A"
else
    pstdev=$( echo "scale=5; sqrt((1/($p-1))*($psumsq-(($psum^2)/$p)))" | bc )
fi

echo "$name;$nmean;$nstdev;$pmean;$pstdev;" >> tmp-num-per.dat

### Calculate width and FDR ###

name="N/A"
wsum=0
wsumsq=0
w=0
fsum=0
fsumsq=0
f=0
root=$peakfolder/
while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8
do
    if [[ $name == "N/A" ]]
    then
        name=$f7
    fi
    
    if [[ $name != $f7 ]]
    then
        wmean=$( echo "scale=3; $wsum/$w" | bc )
        fmean=$( echo "scale=4; $fsum/$f" | bc )

        if [ $w -lt 2 ]
        then
            wstdev="N/A"
        else
            wstdev=$( echo "scale=3; sqrt((1/($w-1))*($wsumsq-(($wsum^2)/$w)))" | bc )
        fi

        if [ $f -lt 2 ]
        then
            fstdev="N/A"
        else
            fstdev=$( echo "scale=4; sqrt((1/($f-1))*($fsumsq-(($fsum^2)/$f)))" | bc )
        fi

        echo "$wmean;$wstdev;$fmean;$fstdev" >> tmp-wid-fdr.dat

        wsum=0
        wsumsq=0
        w=0
        fsum=0
        fsumsq=0
        f=0
        name=$f7
    fi

    w=$(( w + 1 ))
    width=$( cat $root$f8 | awk 'BEGIN{FS="\t";sum=0;n=0}{sum+=($3-$2);n+=1}END{print sum/n}' )
    wsum=$( echo "scale=3; $wsum + $width" | bc )
    wsumsq=$( echo "scale=3; $wsumsq + $width^2" | bc )
    f=$(( f + 1 ))
    fdr=$( cat $root$f8 | awk 'BEGIN{FS="\t";sum=0;n=0}{sum+=($9);n+=1}END{print sum/n}' )
    fsum=$( echo "scale=4; $fsum + $fdr" | bc )
    fsumsq=$( echo "scale=4; $fsumsq + $fdr^2" | bc )
        
done < tmp-cistrome.dat

wmean=$( echo "scale=3; $wsum/$w" | bc )
fmean=$( echo "scale=4; $fsum/$f" | bc )

if [ $w -lt 2 ]
then
    wstdev="N/A"
else
    wstdev=$( echo "scale=3; sqrt((1/($w-1))*($wsumsq-(($wsum^2)/$w)))" | bc )
fi

if [ $f -lt 2 ]
then
    fstdev="N/A"
else
    fstdev=$( echo "scale=4; sqrt((1/($f-1))*($fsumsq-(($fsum^2)/$f)))" | bc )
fi

echo "$wmean;$wstdev;$fmean;$fstdev" >> tmp-wid-fdr.dat

paste -d "" tmp-num-per.dat tmp-wid-fdr.dat > stats.txt

# Cleanup
rm tmp-overlap.dat tmp-cistrome.dat tmp-num-per.dat tmp-wid-fdr.dat