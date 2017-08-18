#!/bin/awk -f

BEGIN {
    FS = "\t"
    OFS = ";"
    current = "N/A"
    sum = 0
    sum_squared = 0
    n = 0
}
{
    if(current == "N/A") {
        current = $7
    }
    # Check if the new element is different from the current
    if($7 != current) {
        mean = sum/n
        if(n < 2) {
            stdev = "N/A"
        } else {
            stdev = sqrt((1/(n-1))*(sum_squared - ((sum^2)/n)))
        }
        print current, mean, stdev
        sum = 0
        sum_squared = 0
        n = 0
        current = $7
    }
    
    filename = "TF_mouse/" $8

    cmd = "wc -l " filename " | awk '{print $1}'"
    cmd | getline n_incr
    close(cmd)
    n += n_incr

    cmd = "cat " filename " | awk -f scripts/width.awk | awk -f scripts/sum.awk"
    cmd | getline sum_incr
    close(cmd)
    sum += sum_incr

    cmd = "cat " filename " | awk -f scripts/width.awk | awk -f scripts/sum_squared.awk"
    cmd | getline sum_squared_incr
    close(cmd)
    sum_squared += sum_squared_incr
}
END {
    mean = sum/n
    stdev = sqrt((1/(n-1))*(sum_squared - ((sum^2)/n)))
    print current, mean, stdev
}
