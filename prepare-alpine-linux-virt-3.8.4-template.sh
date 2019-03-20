#!/bin/bash
######################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS
######################################################
# modified from: jcppkkk/prepare-ubuntu-template.sh
# Tested Alpine Version 3.8.4 Virtual
# http://dl-cdn.alpinelinux.org/alpine/v3.8/releases/x86_64/alpine-virt-3.8.4-x86_64.iso

# SETUP & RUN
# curl -sL https://raw.githubusercontent.com/philipsaad/linux-virt-sysprep/master/prepare-alpine-linux-virt-3.8.4-template.sh | ash

set -v

#enable communitiy packages 
sed -ri '/v3.9\/community/s/^#//g' /etc/apk/repositories

#update the system to the latest packages and caches the community repositorie
apk update
apk upgrade

#install packages
apk add curl nano sudo dropbear chrony htop open-vm-tools 

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
rm -f /etc/dropbear/*

#reset hostname
truncate -s0 /etc/hostname
echo localhost > /etc/hostname

#cleanup apk cache
rm -rf /var/cache/apk/*

# disable swap
swapoff -a

#cleanup shell history
cat /dev/null > ~/.ash_history

#shutdown
halt
