#!/bin/sh
if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters, please provide the server level setting value which default is 70"
    exit
fi

#maxcache=`echo  - | awk -v v1=$1 '{print v1/10.0}'`
maxcache=$1
echo ${maxchche}

blue=$(tput setaf 4)
normal=$(tput sgr0)
green=$(tput setaf 2)

noMemoryLimitOnContainer=9223372036854771712
containerlimit=`cat /sys/fs/cgroup/memory/memory.limit_in_bytes`
baseTotalInBytes=${containerlimit}
hostTotal=`grep MemTotal /proc/meminfo | sed -n -e 's/.* \([[:alnum:]]\+\) .*/\1/p'`
if  [ ${containerlimit}  -eq ${noMemoryLimitOnContainer} ];  then
    #baseTotal=`grep MemTotal /proc/meminfo | sed -n -e 's/.* \([[:alnum:]]\+\) .*/\1/p'`
    baseTotalInBytes=$(( ${hostTotal} * 1024 ))
    noMemoryLimitFlag=1
    printf "${blue}"
    message="\n There is no memory limit configuration on the container. container memory setting: %d bytes, host memory setting: %d kB. \n"
    printf  "${message}"  ${containerlimit}  ${hostTotal}
    printf "${normal}"
    #echo "there is no memory limit configuration on the container. container memory setting: ${containerlimit} bytes, host memory setting: ${hostTotal} kB"
else
    message="\n There is memory limit configuration on the container. container memory setting: %d bytes, host memory setting: %d kB\n"
    printf "${green}"
    printf  "${message}"  ${containerlimit}  ${hostTotal}
    printf "${normal}"
    noMemoryLimitFlag=0
fi

actualTotalInBytes=${baseTotalInBytes}
actualTotalInKBytes=$(( ${baseTotalInBytes}/1024 ))

cd /opt/mstr/MicroStrategy/log
pid=`pgrep MSTRSvr`
sed -n -e 's/.*PID:'"$pid"'.*Server level memory usage is updated: delta = \(.*[[:alnum:]]\+\), usage = \([[:alnum:]]\+\), space = \([[:alnum:]]\+\)/\1 \2 \3/p' cube.log > tmp.log

totalLimitInCubeTrace=`awk '{print $2+$3}' tmp.log | tail -1`
assumedTotalFromLogInKBytes=`echo  - | awk -v v1=${totalLimitInCubeTrace} -v v2=${maxcache} '{v3=v1*100/v2;print int(v3)}'`
assumedTotalFromLogInBytes=`echo  - | awk -v v1=${totalLimitInCubeTrace} -v v2=${maxcache} '{v3=v1*100*1024/v2;print int(v3)}'`
echo $assumedTotalInBytes $assumedTotalInKBytes


header="\n %-30s %-30s %-30s %-30s\n"
format=" %-30s %-30s %-30s %-30s\n"


printf "$header" "actualTotalInBytes" "assumedTotalFromLogInBytes" "actualTotalInKBytes" "assumedTotalFromLogInKBytes"

printf '=%.0s' {1..121}
printf "\n"
printf "$format" ${actualTotalInBytes} ${assumedTotalFromLogInBytes} ${actualTotalInKBytes} ${assumedTotalFromLogInKBytes}
printf '=%.0s' {1..121}
printf "\n"

if [ ${actualTotalInBytes} -ne ${assumedTotalFromLogInBytes} ]; then
    echo actualTotalInBytes         : ${actualTotalInBytes}
    echo assumedTotalFromLogInBytes : ${assumedTotalFromLogInBytes}
    echo actualTotalInBytes - assumedTotalFromLogInBytes : $(( (${actualTotalInBytes}-${assumedTotalFromLogInBytes}) ))
    ratio=$(( (${actualTotalInBytes}-${assumedTotalFromLogInBytes}) ))
    echo  - | awk -v v1=$ratio -v v2=${actualTotalInBytes} '{print v1/v2}'
fi

printf "\n"

if [ ${actualTotalInKBytes} -ne ${assumedTotalFromLogInKBytes} ]; then
    echo actualTotalInKBytes        : ${actualTotalInKBytes}
    echo assumedTotalFromLogInKBytes: ${assumedTotalFromLogInKBytes}
    echo actualTotalInKBytes - assumedTotalFromLogInKBytes: $(( ${actualTotalInKBytes}-${assumedTotalFromLogInKBytes} ))
    ratio=$(( ${actualTotalInKBytes}-${assumedTotalFromLogInKBytes} ))
    echo  - | awk -v v1=$ratio -v v2=${actualTotalInKBytes} '{print v1/v2}'
fi


totalLimitInCubeTraceInMBytes=`echo  - | awk -v v1=${totalLimitInCubeTrace}  '{v2=v1/1024;print int(v2)}'`
servercacheTotalInKBytes=`echo  - | awk -v v1=${actualTotalInBytes}  -v v2=${maxcache} '{v3=v1*v2/100/1024;print int(v3)}'`
servercacheTotalInMBytes=`echo  - | awk -v v1=${actualTotalInBytes}  -v v2=${maxcache} '{v3=v1*v2/100/1024/1024;print int(v3)}'`
printf "\nraw Max. cache in cube trace log: %dKB, %dMB\n" $totalLimitInCubeTrace  $totalLimitInCubeTraceInMBytes
printf "calculated Max. cache in cube trace log: %dKB, %dMB\n" $servercacheTotalInKBytes $servercacheTotalInMBytes
