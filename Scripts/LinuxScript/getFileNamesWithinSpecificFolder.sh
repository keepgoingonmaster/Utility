#!/bin/bash

sourceFolder="/opt/mstr/extractCacheFolder/caches_1000k/Serverenv-184346laio1use1_P163613BB4B34BD0B08CE8AB4828EBE97_1M"
targetFile="filename.csv"
targetFileReport="filenameReport.csv"
ctime=$(date +%Y%m%d%H%M%S)
durationlog="duration_$ctime.log"

start_time=`date +%s`

if [ ! -d $sourceFolder ] ; then
    echo "the $sourceFolder doesn't exist"
    exit -1
fi

if [ ! -f $targetFile ] ; then
    touch $targetFile
else
    rm -rf $targetFile
    touch $targetFile
fi

if [ ! -f $targetFileReport ] ; then
    touch $targetFileReport
else
    rm -rf $targetFileReport
    touch $targetFileReport
fi

if [ ! -f $durationlog ] ; then
    touch $durationlog
fi

for file in $sourceFolder/*
do
    if [ -d $file ] ; then
       for subfile in $file/*
       do
           echo $subfile >> ${targetFile}
       done
    else
        echo $file >> ${targetFileReport}
    fi
done

end_time=`date +%s`

echo test duration is `expr $end_time - $start_time` s >> $durationlog
