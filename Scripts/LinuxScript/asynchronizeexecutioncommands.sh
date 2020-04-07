#!/bin/bash

buildPath=/opt/mstr/MicroStrategy
scriptPath=/opt/mstr/commandscript

for script in ${scriptPath}/*.scp ; do
    nohup $buildPath/bin/mstrcmdmgr -connlessmstr -f ${script} -o $scriptPath/${script}.log &> /dev/null

done
