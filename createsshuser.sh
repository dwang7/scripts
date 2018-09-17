#!/bin/bash
NEWUSER="$1"
shift 
SSH_PUBLIC_KEY="$*"

# run as sudo
function createsshuser()
{
  
  PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

  echo "new password is ${PASSWORD}"
  echo "user is ${NEWUSER}"
  echo "public key is ${SSH_PUBLIC_KEY}"

#  echo "delete user"
#  deluser --force ${NEWUSER}
#  deluser --force --remove-home ${NEWUSER}
 
  echo "add user"
  # create a user with a random password
  adduser --disabled-password --gecos \"\" "${NEWUSER}"

#  echo "change password"
#  echo ${USER}:${PASSWORD} | chpasswd

  # add the user to the sysadmin group so they can "sudo jenkins"
  echo "add group"
  usermod -a -G sysadmin ${NEWUSER}
  usermod -a -G sudo ${NEWUSER}

  echo "add ssh public key"
  # add the ssh public key
  cd /home/${NEWUSER}
  mkdir .ssh 
  echo $SSH_PUBLIC_KEY >> .ssh/authorized_keys
  chown ${NEWUSER}:${NEWUSER} .ssh
  chown ${NEWUSER}:${NEWUSER} .ssh/authorized_keys
  chmod go-rwx .ssh
  chmod go-rwx .ssh/authorized_keys

}

createsshuser
