#!/bin/bash

user=plainbash
allow_root_access=true

# Retrieving user id to use it in chown commands instead of the user name
# to avoid problems on alpine when the user name contains a '.'
uid="$(id -u $user)"
ssh_dir=/home/$user/ssh_keys

# Add SSH keys to authorized_keys with valid permissions
if [ -d $ssh_dir ]; then
	for publickey in $ssh_dir/*; do
		cat $publickey >> /home/$user/.ssh/authorized_keys
	done
	chown $uid /home/$user/.ssh/authorized_keys
	chmod 600 /home/$user/.ssh/authorized_keys
fi

# Add SSH keys to authorized_keys for root access
if [ "$allow_root_access" = true ]; then
	mkdir /root/.ssh
	if [ -d $ssh_dir ]; then
		for publickey in $ssh_dir/*; do
			cat $publickey >> /root/.ssh/authorized_keys
		done
		chmod 600 /root/.ssh/authorized_keys
	fi
fi

# Run ssh-agent
# eval `ssh-agent -s` && ssh-add

# Run ssh server
/usr/sbin/sshd -D
