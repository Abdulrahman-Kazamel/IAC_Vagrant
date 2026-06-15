#!/bin/bash

set -e
yum update -y
yum install epel-release  wget  centos-release-rabbitmq-38 -y

dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server

systemctl enable --now rabbitmq-server


sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

if ! rabbitmqctl list_users | grep -q "^test\s"; then
    rabbitmqctl add_user test test
fi



rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
systemctl restart rabbitmq-server



firewall-cmd --add-port=5672/tcp
firewall-cmd --runtime-to-permanent

                                    