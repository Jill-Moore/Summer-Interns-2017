#!/bin/awk -f 
BEGIN {
    n = 0
}
{
    n += $1^2
}
END {
    print n
}
