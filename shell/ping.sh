#!/bin/sh
for N in {1..200}
do 
ping -c 3 172.18.51.${N} &> /dev/null
if [ $? == 0 ];then
echo "172.18.51.${N} is online!!"
else
echo "172.18.51.${N} is offline!!"
fi
done
