#!/bin/bash  
#set -x  
checkLog=/var/log/check-space.log  
fullFlag=0  
df -h > $checkLog  
percent_list=$(cat $checkLog  | awk '{print $5}' | grep -Eo "[0-9]+")  
for num in $percent_list  
do  
    if [ $num -ge 80 ]; then  
        fullFlag=1  
    fi  
done  
  
if [ $fullFlag -eq 1 ]; then  
    echo "$(hostname): used disk space is more than 80%"|mail -s "warning:disk space is not enough" ***@139.com  
fi  