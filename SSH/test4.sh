#!/bin/sh

user=hadoop
pwd=hadoop
ipfile=~/ip.txt
cat ${ipfile} | while read ip2
do
    cat ${ipfile} | while read ip3
    do
    /usr/bin/expect << EOF
    set time 30
    spawn ssh -p22 ${user}@${ip2}
    expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "${pwd}\r" }
    }
    expect "]\\$ "
    send "ssh ${ip3}\r"
    expect "connecting"
    send "yes\r"
    expect "]\\$ "
    send "exit\r"
    interact
    expect eof
EOF
    done
done
   
echo "login is ok!!"   
   
