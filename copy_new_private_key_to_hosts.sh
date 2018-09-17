#!/bin/bash

RAND=$RANDOM

ssh-keygen -f id_rsa.$RAND -t rsa -N ""

cat id_rsa.$RAND
echo ""
cat id_rsa.$RAND.pub

for server in $(cat ~/bin/hosts.txt); do 
    IP=`echo "$server" | awk 'BEGIN {RS = "|"}; END {print $1}'`;
    HOST=`echo "$server" | awk 'BEGIN {FS = "|"}; END {print $1}'`;
    USER="ubuntu";
    echo "host is $HOST($IP)"
    scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa id_rsa.$RAND.pub $USER@$IP:~
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no  -i ~/.ssh/id_rsa $USER@$IP "mv ~/.ssh/authorized_keys ~/.ssh/authorized_keys.old; mv ~/id_rsa.$RAND.pub ~/.ssh/authorized_keys"
done

cp ~/.ssh/authorized_keys ~/.ssh/authorized_keys.old
cp ~/.ssh/id_rsa ~/.ssh/id_rsa.old
cp ~/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub.old

cp id_rsa.$RAND.pub ~/.ssh/id_rsa.pub
mv -f id_rsa.$RAND.pub ~/.ssh/authorized_keys
mv -f id_rsa.$RAND ~/.ssh/id_rsa

#rm id_rsa.$RAND
#rm id_rsa.$RAND.pub
