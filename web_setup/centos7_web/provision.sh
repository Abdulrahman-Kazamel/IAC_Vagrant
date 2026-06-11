#!/bin/bash

 #  this line will cause the script to exit immediately 
 # if any command exits with a non-zero status,
 # if any variable is used but not defined, or if any command in a pipeline fails.
set -euo pipefail 

#yum update -y

echo "############################# updating repo list.... ##########################"
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Base.repo
sed -i 's/#baseurl=http:\/\/mirror.centos.org/baseurl=https:\/\/vault.centos.org/g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all > /dev/null
yum makecache > /dev/null


echo "############################# save system state... ##########################"
mkdir -p /opt/vagrant
free -m >> /opt/vagrant/ram.txt
df -h >> /opt/vagrant/disk.txt


echo "############################# installing project dependancies... ##########################"
yum install httpd wget vim unzip  -y > /dev/null


echo "###########################   enabling mandatory services...    ##########################"

if ! systemctl is-active httpd; then
      systemctl enable  --now httpd
fi

if ! systemctl is-active firewalld; then
      #systemctl unmask firewalld
      systemctl enable --now firewalld  
fi

echo "###########################  downloading project repo...    ##########################"
cd /tmp
wget -o 2103_central.zip https://www.tooplate.com/zip-templates/2103_central.zip > /dev/null

unzip 2103_central.zip > /dev/null
cp -r 2103_central/* /var/www/html/ 



echo "########################### restarting firewall & http service...  ##########################"
systemctl restart httpd  


firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=22/tcp --permanent
firewall-cmd --reload
