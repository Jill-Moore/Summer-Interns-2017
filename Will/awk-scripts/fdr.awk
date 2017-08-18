#!/bin/awk -f
BEGIN{
    FS = "\t"
}
{
    print $9
}
END {

}
