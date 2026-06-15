#!/bin/bash

set -e

# dnf clean all
# rm -rf /var/cache/dnf

# dnf distro-sync -y --allowerasing
yum update -y && yum upgrade -y

yum install nginx -y

# mkdir -p /etc/nginx/sites-available
# mkdir -p /etc/nginx/sites-enabled


cat <<EOT > /etc/nginx/conf.d/vproapp.conf
upstream vproapp {
    server app01:8080;
}
server {
    listen 80;
    location / {
    proxy_pass http://vproapp;
  }
}
EOT






systemctl restart nginx