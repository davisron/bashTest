#!/bin/sh

hostfile=/tmp/host.txt
rootpwd=123456

cat $hostfile | while read line
do
ip=`echo $line | awk '{print $1}'`
user=`echo $line | awk '{print $2}'`
pwd=`echo $line | awk '{print $3}'`
expect -c "
spawn ssh root@${ip} useradd $user
expect {
	"yes/no" {send "yes\\r";expect "password" {send "${rootpwd}\\r"}}
	"password" {send "${rootpwd}\\r"}
	}
expect eof
spawn ssh root@${ip} echo $pwd | passwd --stdin $user
expect {
	"yes/no" {send "yes\\r";expect "password" {send "${rootpwd}\\r"}}
	"password" {send "${rootpwd}\\r"}
	}
expect eof
"

done

