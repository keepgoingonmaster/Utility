#!/bin/bash

buildPath=/build/$1/$2/BIN/Linux
scriptPath=/build/clusterCaches/script
script="${scriptPath}/$3"

ctime=$(date +%Y%m%d%H%M%S)
outputlog=${scriptPath}/output/$3_$ctime.log

nohup $buildPath/bin/mstrcmdmgr -connlessmstr -f ${script} -o ${outputlog} &> /dev/null
