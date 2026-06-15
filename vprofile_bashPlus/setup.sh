#!/bin/bash 
USER="kazamel"
export USER

for i in $(cat remote_hosts.txt); do
    echo "copping script to server $i"
    sleep 2
    scp scripts/$i.sh $USER@$i:/tmp/
    echo "deploying script to server $i"
    ssh $USER@$i "sudo chmod +x /tmp/$i.sh &&sudo /tmp/$i.sh"
    echo "Script deployed to server $i"
    echo "---------------------------------------------"
   

done