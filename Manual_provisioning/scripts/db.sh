#!/bin/bash

set -e
yum update -y
yum install epel-release -y

yum install -y mariadb-server git
systemctl start mariadb
systemctl enable mariadb

#starting the firewall and allowing the mariadb to access from port no. 3306
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb