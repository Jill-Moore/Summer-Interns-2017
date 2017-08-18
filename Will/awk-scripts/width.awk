#!/bin/awk -f 

BEGIN {
    FS = "\t"
}
{
    print $3-$2
}
END {

}
