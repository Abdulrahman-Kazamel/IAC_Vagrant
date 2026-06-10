#!/bin/bash

set -e
yum update -y
yum install epel-release -y

yum -y install java-17-openjdk java-17-openjdk-devel

yum install git wget tar zip unzip -y


cd /tmp/
rm -rf apache-tomcat-10.*
# wget -O apache-tomcat-10.tar.gz https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.55/bin/apache-tomcat-10.1.55.tar.gz

wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.55/bin/apache-tomcat-10.1.55.tar.gz

tar -xzvf apache-tomcat-10.1.55.tar.gz


if ! id "tomcat" &>/dev/null; then
    useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
fi

cp -r apache-tomcat-10.1.55/* /usr/local/tomcat/

chown -R tomcat:tomcat /usr/local/tomcat

cat <<EOT > /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target
[Service]
User=tomcat
Group=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
RestartSec=10
Restart=always
[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat   


##########################code build and deploy##########################
cd /tmp/
# rm -rf apache-maven-3.9*
# wget https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip
# unzip apache-maven-3.9.9-bin.zip
# mkdir -p /usr/local/maven3.9
# rm -rf /usr/local/maven3.9/*
# cp -r apache-maven-3.9.9/* /usr/local/maven3.9
yum install maven -y
export MAVEN_OPTS="-Xmx512m"
rm -rf vprofile-project
## source code
# if [ ! -d vprofile-project ]; then
    git clone -b local https://github.com/hkhcoder/vprofile-project.git
# fi
cd vprofile-project

mvn  install 

systemctl stop tomcat
sleep 20
mkdir -p /usr/local/tomcat/webapps
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
chown tomcat.tomcat /usr/local/tomcat/webapps -R
systemctl start tomcat
sleep 20
systemctl stop firewalld
systemctl disable firewalld
