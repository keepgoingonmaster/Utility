#!/bin/sh

pushd /opt/mstr/MicroStrategy/log

pid=`pgrep MSTRSvr`
grep -i -e ".*PID:$pid.*PrintServerDef: Memory throttling: Private Bytes" DSSErrors.log
grep -i -e ".*PID:$pid.*PrintServerDef: Contract Manager Settings:.*Limit" DSSErrors.log
grep -i -e ".*PID:$pid.*PrintServerDef: Project Info - Cube information: cube file path" DSSErrors.log

printf "\n%-20s %-20s %-20s\n"  'Private Bytes (%)' 'Virtual Bytes (%)'  'Avail Phys Mem (%)'
printf '=%.0s' {1..60}
printf "\n"

pid=`pgrep MSTRSvr`
sed -n -e 's/.*PID:'"$pid"'.*PrintServerDef: Memory throttling: Private Bytes (%) = \([[:alnum:]]\+\), Virtual Bytes (%) = \([[:alnum:]]\+\), Avail Phys Mem (%) = \([[:alnum:]]\+\)/\1 \2 \3/p'  DSSErrors.log > setting.log
awk  -F " " '{printf "%-20s %-20s %-20s\n",  $1, $2, $3}' setting.log
#printf '=%.0s' {1..60}
#printf "\n"


printf "\n%-15s %-20s %-28s %-15s\n"  'Limit(MBytes)' 'Limit(%)'  'Reserve(MBytes)' 'Reserve(%)'
printf '=%.0s' {1..78}
printf "\n"

pid=`pgrep MSTRSvr`
sed -n -e 's/.*PID:'"$pid"'.*PrintServerDef: Contract Manager Settings:.*Limit(MBytes) = \([[:alnum:]]\+\), Limit(%) = \(.*[[:alnum:]]\+\), Reserve(MBytes) = \(.*[[:alnum:]]\+\), Reserve(%) = \([[:alnum:]]\+\)/\1 \2 \3 \4/p'  DSSErrors.log > setting.log
awk  -F " " '{printf "%-15s %-20s %-28s %-15s\n",  $1, $2, $3, $4}' setting.log
#printf '=%.0s' {1..78}
#printf "\n"


printf "\n%-8s %-25s %-25s %-20s\n"  'size' 'max_cube_cache_count'  'cube_DB_match_flag' 'publish_flag'
printf '=%.0s' {1..78}
printf "\n"

pid=`pgrep MSTRSvr`
sed -n -e 's/.*PID:'"$pid"'.*PrintServerDef: Project Info - Cube information: cube file path:.*, size:\([[:alnum:]]\+\)MB, max cube cache count: \([[:alnum:]]\+\), cube DB match flag: \([[:alnum:]]\+\), publish flag: \([[:alnum:]]\+\)/\1 \2 \3 \4/p'  DSSErrors.log > setting.log
awk  -F " " '{printf "%-8s %-25s %-25s %-20s\n",  $1, $2, $3, $4}' setting.log
#printf '=%.0s' {1..78}
#printf "\n"
