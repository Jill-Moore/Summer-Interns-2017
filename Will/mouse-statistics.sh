#!/bin/bash

# Go through each line of the mouse file
cat Cistrome-IDs.txt | awk '
BEGIN {
    FS = "\t"
    OFS = ";"
}
{
    # Variable names
    C_ID = $1
    C_L_NAME = $4
    C_TYPE = $5
    C_T_CAT = $6
    H_MARK = $7
    FILENAME = ("histone_mouse/" $8)
    N_PEAKS = "N/A"
    N_O_PEAKS = "N/A"
    
    # Calculate the number of peaks
    # CMD = "wc -l < " FILENAME
    # CMD | getline N_PEAKS
    # close(CMD)  

    # Calculate the number of overlapping peaks
    # CMD = "bedtools intersect -u -a " FILENAME " -b mm10-cREs.bed | wc -l"
    # CMD | getline N_O_PEAKS
    # close(CMD)

    # Appends the new line to the output file
    # print C_ID, H_MARK, C_L_NAME, C_TYPE, C_T_CAT, N_PEAKS, N_O_PEAKS
    # print C_ID, H_MARK, C_L_NAME, C_TYPE, C_T_CAT, N_PEAKS, N_O_PEAKS >> "output.txt"    
    print H_MARK, FILENAME >> "files.txt"
}'
