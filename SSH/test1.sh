#!/bin/sh

user=root
pwd=123456
cat /tmp/ip.txt | while read ip
do
   # id $user >& /dev/null
   # if [ $? -ne 0 ]
   # then
   #     useradd $user;
   #     echo $user | passwd --stdin $user
   # fi
    expect -c "
    spawn ssh ${user}@${ip} ssh-keygen -t rsa
    expect {
    \"connecting\" {send \"yes\r\"; exp_continue}
    \"password:\" {send \"${pwd}\r\"; exp_continue}
    \"save the key\" {send \"\r\"; exp_continue}
    \"empty for no passphrase\" {send \"\r\"; exp_continue}
    \"passphrase again\" {send \"\r\r\";}
    }
    "
done

cat /tmp/ip.txt | while read ip2
do
   cat /tmp/ip.txt | while read ip3
   do
   expect -c "
   spawn scp ${user}@${ip2}:~/.ssh/id_rsa.pub ${user}@${ip3}:/tmp/id_rsa.pub
   expect {
   \"connecting\" {send \"yes\r\"; exp_continue}
   \"password:\" {send \"${pwd}\r\"; exp_continue}
   \"connecting\" {send \"yes\r\"; exp_continue}
   \"password:\" {send \"${pwd}\r\";}
   }
   "
   /usr/bin/expect << EOF
   set time 30
   spawn ssh -p22 ${user}@${ip3}
   expect {
   "*yes/no" { send "yes\r"; exp_continue }
   "*password:" { send "${pwd}\r" }
   }
   expect "$"
   send "cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys\r"
   expect "$"
   send "chmod 600 ~/.ssh/authorized_keys\r"
   expect "$"
   send "\r"
EOF
 done
   
done

echo "ssh is finish!!"

