#!/bin/awk -f

BEGIN {
    FS = "\t"
    OFS = ";"
}
{
    # Get the number of total peaks
    cmd = "wc -l < TF_mouse/" $8
    cmd | getline total
    close(cmd)

    # Get the number of overlapping peaks
    cmd = "bedtools intersect -u -a TF_mouse/" $8 " -b mm10-cREs.bed | wc -l"
    cmd | getline over
    close(cmd)

    print $1, $7, $4, $5, $6, total, over
    print $1, $7, $4, $5, $6, total, over >> "raw-tf-peak-overlap-fixed.txt"
}
END {

}
