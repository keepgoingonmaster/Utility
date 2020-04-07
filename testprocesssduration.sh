#!/usr/bin/bash

start_time=`date +%s`
durationlog="/opt/mstr/MicroStrategy/extract1.log"
extractresult="/opt/mstr/extractresult/folder1/subfold2/subfold3/"

if [ ! -f ${durationlog} ]; then
    touch ${durationlog}
fi

if [ ! -d ${extractresult} ]; then
    mkdir -p ${extractresult}
fi


cd /opt/mstr
tar zxvf test_1800000.tar.gz --directory ${extractresult}  &> /dev/null
end_time=`date +%s`

echo execution time is `expr $end_time - $start_time` s

echo execution time is `expr $end_time - $start_time` s >> ${durationlog}
