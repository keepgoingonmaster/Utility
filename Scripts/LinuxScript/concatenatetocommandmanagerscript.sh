#!/bin/bash

sourcefile="bucket_10_702.log"
targetfile="${sourcefile::-4}.scp"

if [ ! -f ${sourcefile} ] ; then
    echo ${sourcefile} "doesn't exist"
    exit -1
fi

if [ ! -f ${sourcefile} ] ; then
    touch ${targetfile}
else
    rm -rf ${targetfile}
    touch ${targetfile}
    echo "CONNECT SERVER \"127.0.0.1\" USER \"administrator\" PASSWORD \"KnxGkM0KOslt\" PORT 34952;" >> $targetfile
fi

prefix="LOAD DOCUMENT CACHES GUID "
sufix=" IN PROJECT \"Usher Analytics Self Service\";"

while IFS= read -r line
do 
    string="${prefix}${line}${sufix}"
    echo $string >> $targetfile
done < "${sourcefile}"

echo "DISCONNECT SERVER;" >> $targetfile
