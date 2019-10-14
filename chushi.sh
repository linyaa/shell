#!/bin/bash
#####
yumyuan(){
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo&&yum -y install wget && wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
}
IP(){
echo "TYPE=Ethernet
BOOTPROTO=none
DEVICE=ens33
ONBOOT=yes
IPADDR=10.3.145.$i
NETMASK=255.0.0.0
GATEWAY=10.3.145.1
DNS1=223.5.5.5
DNS2=223.6.6.6" >/etc/sysconfig/network-scripts/ifcfg-ens33&&ifdown ens33&&ifup ens33&&echo "配置IP成功！！" ||echo " 请重试！！"
        hostname $j
        echo "$j" > /etc/hostname &&echo "配置主机名成功！！"||echo " 请重试！！"
}
IP2(){
read -p  "请输入IP最后两位：" i
echo
echo "TYPE=Ethernet
BOOTPROTO=none
DEVICE=ens33
ONBOOT=yes
IPADDR=10.3.145.$i
NETMASK=255.0.0.0
GATEWAY=10.3.145.1
DNS1=223.5.5.5
DNS2=223.6.6.6" >/etc/sysconfig/network-scripts/ifcfg-ens33&&ifdown ens33&&ifup ens33&&echo "配置IP成功！！" ||echo " 请重试！！"
}
VIM(){
yum install vim -y
echo "set tabstop=4" >> /etc/vimrc
export EDITOR=vim&&echo " 成功！！"||echo " 请重试！！"
}
BAS(){
yum install bash-completion -y&&echo "成功！！"||echo " 请重试！！"
}

firewd(){
	systemctl stop firewalld 
	systemctl disable firewalld
	setenforce 0
	echo SELINUX=disabled > /etc/selinux/config
}
i=$1
j=$2
yumyuan
firewd
IP
VIM
BAS
