#!/bin/bash

yum update -y

mkdir -p /opt/vagrant

free -m > /opt/vagrant/ram.txt
df -h > /opt/vagrant/disk.txt

yum install -y httpd wget vim unzip zip

systemctl enable httpd
systemctl start httpd

systemctl disable firewalld
systemctl stop firewalld
systemctl mask firewalld

echo "<h1>WEB01 Rocky Linux</h1>" > /var/www/html/index.html