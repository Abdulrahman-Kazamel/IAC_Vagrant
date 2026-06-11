#!/bin/bash

 #  this line will cause the script to exit immediately 
 # if any command exits with a non-zero status,
 # if any variable is used but not defined, or if any command in a pipeline fails.
set -euo pipefail 

#yum update -y


#### script Variables.
PACKAGES="httpd wget vim unzip"
URL="https://www.tooplate.com/zip-templates/2103_central.zip"
ARTIFACT_NAME="2103_central"
MAIN_SVC="httpd"




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
yum install $PACKAGES  -y > /dev/null


echo "###########################   enabling mandatory services...    ##########################"

if ! systemctl is-active $MAIN_SVC; then
      systemctl enable  --now httpd
fi

if ! systemctl is-active firewalld; then
      #systemctl unmask firewalld
      systemctl enable --now firewalld  
fi

echo "###########################  downloading project repo...    ##########################"
cd /tmp
rm -rf $ARTIFACT_NAME
wget -O $ARTIFACT_NAME.zip $URL > /dev/null

unzip $ARTIFACT_NAME.zip > /dev/null
cp -r $ARTIFACT_NAME/* /var/www/html/ 



echo "########################### restarting firewall & http service...  ##########################"
systemctl restart $MAIN_SVC 


firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=22/tcp --permanent
firewall-cmd --reload
