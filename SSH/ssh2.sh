#!/bin/sh
# this script need file of host.txt
# format of host.txt is :
# 192.168.0.1 root root
################################################
                                               #
hostfile=/tmp/host.txt                         #
                                               #
################################################



cat $hostfile | while read line
do
ip=`echo $line | awk '{print $1}'`
user=`echo $line | awk '{print $2}'`
pwd=`echo $line | awk '{print $3}'`
expect -c "
spawn ssh ${user}@${ip} ssh-keygen -t rsa
expect {
"yes/no" {send "yes\\r";expect "password" {send "${pwd}\\r"}}
"password" {send "${pwd}\\r"}
}
expect "save" {send "\\r"}
expect "passphrase" {send "\\r"}
expect "passphrase" {send "\\r"}
expect eof
"
done


cat $hostfile | while read line
do
ip=`echo $line | awk '{print $1}'`
user=`echo $line | awk '{print $2}'`
pwd=`echo $line | awk '{print $3}'`

	cat $hostfile | while read line2
	do
	ip2=`echo $line2 | awk '{print $1}'`
	user2=`echo $line2 | awk '{print $2}'`
	pwd2=`echo $line2 | awk '{print $3}'`	
	expect -c "
	spawn scp ${user}@${ip}:~/.ssh/id_rsa.pub ${user2}@${ip2}:~/key.pub
	expect {
	"yes/no" {send "yes\\r";expect "password" {send "${pwd}\\r"}}
	"password" {send "${pwd}\\r"}
	}
	expect {
	"yes/no" {send "yes\\r";expect "password" {send "${pwd2}\\r"}}
	"password" {send "${pwd2}\\r"}
	}
	expect eof
	spawn ssh ${user2}@${ip2} cat ~/key.pub >> ~/.ssh/authorized_keys
	expect {
	"yes/no" {send "yes\\r";expect "password" {send "${pwd2}\\r"}}
	"password" {send "${pwd2}\\r"}
	}
	expect eof
	spawn ssh ${user2}@${ip2} chmod 600 ~/.ssh/authorized_keys
	expect {
        "yes/no" {send "yes\\r";expect "password" {send "${pwd2}\\r"}}
        "password" {send "${pwd2}\\r"}
        }
	expect eof
	"
	done
done
