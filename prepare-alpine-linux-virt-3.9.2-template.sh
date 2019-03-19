#!/bin/bash
######################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS
######################################################
# modified from: jcppkkk/prepare-ubuntu-template.sh
# Tested Alpine Version 3.9.2 Virtual
# http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/x86_64/alpine-virt-3.9.2-x86_64.iso

# SETUP & RUN
# curl -sL https://raw.githubusercontent.com/philipsaad/linux-virt-sysprep/master/prepare-alpine-linux-virt-3.9.2-template.sh | sudo -E bash -

if [ `id -u` -ne 0 ]; then
	echo Need sudo
	exit 1
fi

set -v

#update apt-cache
apk update -y
apk upgrade -y

#install packages
apk install open-vm-tools

#Stop services for cleanup
service syslog stop

#clear audit logs
if [ -f /var/log/wtmp ]; then
    truncate -s0 /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    truncate -s0 /var/log/lastlog
fi

#cleanup /tmp directories
rm -rf /tmp/*
rm -rf /var/tmp/*

#cleanup current ssh keys
rm -f /etc/ssh/ssh_host_*

#reset hostname
truncate -s0 /etc/hostname

#cleanup apk cache
rm -rf /var/cache/apk/*

# disable swap
sudo swapoff --all
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

#cleanup shell history
cat /dev/null > ~/.bash_history && history -c
history -w

#shutdown
halt
