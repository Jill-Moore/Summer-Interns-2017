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
        current = $2
    }
    # Check if the new element is different from the current
    if($2 != current) {
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
        current = $2
    }
    
    n += 1
    sum += ($7 / $6)
    sum_squared += ($7 / $6)^2
}
END {
    mean = sum/n
    stdev = sqrt((1/(n-1))*(sum_squared - ((sum^2)/n)))
    print current, mean, stdev
}
