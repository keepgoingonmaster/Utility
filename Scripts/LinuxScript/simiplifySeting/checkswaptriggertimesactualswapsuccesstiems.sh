#!/bin/bash

red=$(tput setaf 1)
green=$(tput setaf 2)
bold=$(tput bold)
normal=$(tput sgr0)

filelog="/opt/mstr/MicroStrategy/log/cube.log"
factor=2

if [ ! -f ${filelog} ]; then
    printf "${red}"
    printf "The cube trace log ${filelog} is not enabled. "
    printf  "${normal}"
    exit
fi

pid=`pgrep MSTRSvr`


awk '/Cube Manager:Swap: for cube instance/ {print}' cube.log > tmp_swap.log

swappattern='(THR:.*?) Cube Manager:Swap:.*for cube instance (.*?) needing size (.*?)K, attempt'

swapTriggerNO=`wc -l tmp_swap.log `
swapDoneNO=0

while IFS= read -r line
do
   if [[  ${line} =~ ${swappattern} ]]; then   
        targetline_part1="${BASH_REMATCH[1]} Loading cube instance"
        targetline_part2="${BASH_REMATCH[2]}.cube, full load = Yes"

        targetline_part1=$(echo "$targetline_part1" | sed 's/\[/\\\[/g')
        targetline_part1=$(echo "$targetline_part1" | sed 's/\]/\\\]/g')


        matchresult=`sed -n -e "/${targetline_part1}.*${targetline_part2}/p" cube.log`        

        if [ ! -z "${matchresult}" ]; then
            echo $line
            echo ${matchresult}
            printf "${green}"
            printf "swap successfully\n"
            printf "${normal}"
            swapDoneNO=$(( ${swapDoneNO}+1 ))
            echo $swapDoneNO
        else
            printf "${red}"
            printf "cube cache %s is not loaded successfully by swapping\n" ${BASH_REMATCH[2]}
            printf "${normal}"
        fi
   fi
done  < tmp_swap.log

printf "expected swap times %d, actual swap times %d \n" ${swapDoneNO} ${swapTriggerNO}
