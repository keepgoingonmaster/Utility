#!/usr/bin/bash

sourcefile="/efs/saas_data/caches/cloud_10s/output.txt"
durationlog="/opt/mstr/MicroStrategy/parsecacheduration.txt"

if [ ! -f ${durationlog} ] ; then
   touch ${durationlog}
fi

start_time=`date +%s`
while IFS= read -r line
do
	#if [[ $line =~ "bucket ([0-9]+): ([0-9]+)" ]] ; then
	if [[ $line =~ "bucket" ]] ; then
            bucketfile=`echo $line | egrep -io "[0-9]+:" | egrep -o "[0-9]+"`
            bucketsize=`echo $line | egrep -io ": [0-9]+" | egrep -o "[0-9]+"`
	    echo ${bucketfile} ${bucketsize}
            filename="bucket_${bucketfile}_${bucketsize}.log"
            if [ -f ${filename} ] ; then
               rm -rf  ${filename}
               touch ${filename}
            else
               touch ${filename}
            fi
        else
            cacheID=`echo $line | egrep -io ":[[:space:]][0-9a-z]+" | egrep -io "[0-9a-z]+"`
            echo ${cacheID} >> ${filename} 
        fi
done < "${sourcefile}"

end_time=`date +%s`
echo execution time is `expr $end_time - $start_time` s
echo execution time is `expr $end_time - $start_time` s >> ${durationlog}
