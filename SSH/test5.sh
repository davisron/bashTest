
#!/bin/expect

 

#循环1000台机器的IP地址，生成密钥文件authorized_keys

 

for ip in {cat ip.list}

do

    ssh user@$ip ssh-keygen -t rsa  &>/dev/null

    expect{

                "yes/no" { send "yes\r";exp_continue}

                "password:"{send "$passwd\r";exp_continue}

              }

    cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys &> /dev/null  

    exit

    if [ !-f ~/.ssh/authorized_keys ];<br>    then

       touch ~/.ssh/authorized_keys<br>    fi

    ssh user@$ip cat ~/.ssh/authorized_keys >> ~/.ssh/authorized_keys  &> /dev/null

    expect{

                "yes/no" { send "yes\r";exp_continue}

                "password:"{send "$passwd\r";exp_continue}

              }   

done

 

#scp authorized_keys 文件到各台机器上面。

for ip in {cat ip.list}

do

   scp ~/.ssh/authorized_keys user@$ip:~/.ssh/ 

    expect{

                "yes/no" { send "yes\r";exp_continue}

                "password:"{send "$passwd\r";exp_continue}

              }  

done