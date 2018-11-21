#!/bin/sh

#this script will update hostname,ip,hosts file,selinux,firewall
#this script will create user and password,create ssh key,

hostname=fff
ip=192.168.100.100







cat << EOF > /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=${hostname}
EOF
hostname ${hostname}




grep DEVICE /etc/sysconfig/network-scripts/ifcfg-eth0 > /tmp/ip.txt
grep UUID /etc/sysconfig/network-scripts/ifcfg-eth0 >> /tmp/ip.txt
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
BOOTPROTO=static
IPADDR=${ip}
NETMASK=255.255.255.0
IPV6INIT=yes
NM_CONTROLLED=yes
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
EOF
cat /tmp/ip.txt >> /etc/sysconfig/network-scripts/ifcfg-eth0 
service network restart



cat << EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.0.192	 BG4N01
192.168.0.189	 BG4N02
192.168.0.190	 BG4N03
192.168.0.191	 BG4N04
EOF


sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config


chkconfig iptables off
service iptables stop

useradd hadoop;echo "hadoop" | passwd --stdin hadoop




