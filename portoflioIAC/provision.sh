#!/bin/bash

 #  this line will cause the script to exit immediately 
 # if any command exits with a non-zero status,
 # if any variable is used but not defined, or if any command in a pipeline fails.
set -euo pipefail 

# dnf clean all
# dnf makecache
# dnf update -y --allowerasing

dnf update -y --nobest --skip-broken || false

mkdir -p /opt/vagrant
free -m >> /opt/vagrant/ram.txt
df -h >> /opt/vagrant/disk.txt
     
dnf install httpd wget vim unzip zip -y

if ! systemctl is-active httpd; then
      systemctl enable  --now httpd
fi

if ! systemctl is-active firewalld; then
      systemctl unmask firewalld
      systemctl enable --now firewalld  
fi

chown -R apache:apache /var/www/html

# this command will set the permissions of directories to 755 and files to 644, 
#which is a common practice for web server files. 

find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

#The restorecon command will restore the SELinux context of the files and directories to their default values, 
#which is important for security and proper functioning of the web server.
restorecon -Rv /var/www/html

systemctl restart httpd  
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --add-port=22/tcp --permanent
firewall-cmd --reload
