#! /bin/bash

NAMENET=$(netstat -i | grep "enp*" | cut -f1 -d " ")

###################### Add User ######################
read -p "Choose username for new user: " username
sudo adduser $username
sudo usermod -aG sudo $username

###################### Start update and install package ######################
sudo apt-get update
sudo apt-get upgrade

sudo apt-get install net-tools
sudo apt-get install iptables-persistent
sudo apt-get install nano
sudo apt-get install postfix
sudo apt-get install mailutils
sudo apt-get install fail2ban

###################### Network ######################
mv /etc/network/interfaces /etc/network/interfaces.old
mv interfaces /etc/network/
sudo service networking restart
ifdown $NAMENET
ifup $NAMENET

###################### SSH ######################
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old
mv sshd_config /etc/ssh/
sudo service ssh restart

###################### Install scripts ######################
mkdir /var/scripts
mv alert.sh /var/scripts && mv udpate.sh /var/scritps
mv /etc/crontab /etc/crontab.old
mv crontab /etc/
