#!/bin/sh

#this script will update hostname,ip,hosts file,selinux,firewall
#this script will create user and password,create ssh key,
#default netmask 255.255.255.0
########################################


hostname=fff
ip=192.168.100.100


########################################

chkconfig iptables off
chkconfig ip6tables off
chkconfig NetworkManager off
service iptables stop
service ip6tables stop
service NetworkManager stop

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

########################################

cat << EOF > /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=${hostname}
EOF
hostname ${hostname}

########################################

grep HWADDR /etc/sysconfig/network-scripts/ifcfg-eth0 > /tmp/ip.txt
grep UUID /etc/sysconfig/network-scripts/ifcfg-eth0 >> /tmp/ip.txt
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
BOOTPROTO=none
IPV6INIT=yes
NM_CONTROLLED=yes
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
IPADDR=${ip}
NETMASK=255.255.255.0
EOF

#GATEWAY=172.18.50.1

cat /tmp/ip.txt >> /etc/sysconfig/network-scripts/ifcfg-eth0 
service network restart

########################################

cat << EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.0.150    host0.vm.com
192.168.0.151    host1.vm.com
192.168.0.152    host2.vm.com
192.168.0.153    host3.vm.com
EOF

########################################
#  
#  useradd hadoop;
#  echo "hadoop" | passwd --stdin hadoop
#  
########################################
