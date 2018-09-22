#!/bin/bash

if (( EUID == 0 )); then
   echo "You must not be root to do this." 1>&2
   exit 100
fi

for server in $(cat ~/bin/hosts.txt); do 
    IP=`echo "$server" | awk 'BEGIN {RS = "|"}; END {print $1}'`;
    HOST=`echo "$server" | awk 'BEGIN {FS = "|"}; END {print $1}'`;
    USER="ubuntu";
    echo "host is $HOST($IP)"
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ~/.ssh/id_rsa $USER@$IP "cp ~/.ssh/authorized_keys.old ~/.ssh/authorized_keys"
done

cp ~/.ssh/authorized_keys.old ~/.ssh/authorized_keys
cp ~/.ssh/id_rsa.old ~/.ssh/id_rsa
cp ~/.ssh/id_rsa.pub.old ~/.ssh/id_rsa.pub
