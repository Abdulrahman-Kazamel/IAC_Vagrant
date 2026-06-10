#!/bin/bash

apt-get update -y

mkdir -p /opt/vagrant

free -m > /opt/vagrant/ram.txt
df -h > /opt/vagrant/disk.txt

apt-get install -y apache2 vim wget unzip zip

systemctl enable apache2
systemctl start apache2

echo "<h1>WEB02 Ubuntu 22.04</h1>" > /var/www/html/index.html