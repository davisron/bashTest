#!/bin/sh

hostfile=/tmp/host.txt
cmd=$1

cat $hostfile | while read line
do
ip=`echo $line | awk '{print $1}'`
user=`echo $line | awk '{print $2}'`
pwd=`echo $line | awk '{print $3}'`
expect -c "
spawn ssh ${user}@${ip} $cmd
expect {
	"yes/no" {send "yes\\r";expect "password" {send "${pwd}\\r"}}
	"password" {send "${pwd}\\r"}
	}
expect eof
"

done

