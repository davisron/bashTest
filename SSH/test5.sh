
#!/bin/expect

 

#ѭ��1000̨������IP��ַ��������Կ�ļ�authorized_keys

 

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

 

#scp authorized_keys �ļ�����̨�������档

for ip in {cat ip.list}

do

   scp ~/.ssh/authorized_keys user@$ip:~/.ssh/ 

    expect{

                "yes/no" { send "yes\r";exp_continue}

                "password:"{send "$passwd\r";exp_continue}

              }  

done