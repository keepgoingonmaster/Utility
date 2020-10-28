#!/bin/bash
input="/opt/mstr/MicroStrategy/log/ids.txt"
outputlog="/opt/mstr/MicroStrategy/log/command.log"
commandfile="/opt/mstr/MicroStrategy/log/publish.scp"

tool="/opt/mstr/MicroStrategy/bin/mstrcmdmgr"

while IFS= read -r line
do
  echo "$line"
  sed -i -r "s/GUID (.*?) FOR/GUID ${line} FOR/" $commandfile
  #cat $commandfile
  
  nohup ${tool} -connlessmstr -f ${commandfile} -o ${outputlog} &> /dev/null
  sleep 90
done < "$input"
