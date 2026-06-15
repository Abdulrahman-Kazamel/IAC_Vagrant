#!/bin/bash

USER="username"
export USER="username"

if ! id $USER &>/dev/null; then
    useradd -m -s /bin/bash $USER 
fi

echo "$USER:password" | chpasswd 
usermod -aG wheel $USER
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd


echo "kazamel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/kazamel
chmod 440 /etc/sudoers.d/kazamel
