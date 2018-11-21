#!/bin/sh
temp=$(df | grep -Eo "[0-9]+"% | grep -Eo "[0-9]+")
for num in $temp
do
if [ $num -ge 18 ]
then 
	echo 'WARN!!!:The highest use rate of the hard disk is '"${num}%" | mail  -s 'DISK WARN!!!' hfeng@139.com

	exit
fi
done
exit
