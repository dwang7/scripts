#!/bin/bash
NEWUSER="$1"
shift
SSH_PUBLIC_KEY="$*"

if (( EUID != 0 )); then
   echo "You must be root to do this." 1>&2
   exit 100
fi

for server in $(cat ~/bin/hosts.txt); do 
    IP=`echo "$server" | awk 'BEGIN {RS = "|"}; END {print $1}'`;
    HOST=`echo "$server" | awk 'BEGIN {FS = "|"}; END {print $1}'`;
    USER="ubuntu";
    echo "host is $HOST($IP)"
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ~/.ssh/id_rsa $USER@$IP sudo ./createsshuser.sh $NEWUSER $SSH_PUBLIC_KEY
done
