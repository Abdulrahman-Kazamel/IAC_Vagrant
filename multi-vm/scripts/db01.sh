#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update -y

apt-get install -y mysql-server

systemctl enable mysql
systemctl start mysql

sed -i \
's/^bind-address.*/bind-address = 0.0.0.0/' \
/etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql

mysql -e "ALTER USER 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';"

mysql -e "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'P@ssw0rd';"

mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;"

mysql -e "FLUSH PRIVILEGES;"