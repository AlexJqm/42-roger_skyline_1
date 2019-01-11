#! /bin/bash

NAMENET=$(netstat -i | grep "enp*" | cut -f1 -d " ")

###################### Install SUDO ######################
apt-get install sudo

###################### Add User ######################
read -p "Choose username for new user: " username
sudo adduser $username
sudo usermod -aG sudo $username

###################### Start update and install package ######################
sudo apt-get update
sudo apt-get upgrade

sudo apt-get build-dep build-essential
sudo apt-get install net-tools
sudo apt-get install iptables-persistent
sudo apt-get install sudo
sudo apt-get install zsh
sudo apt-get install git
sudo apt-get install nano
sudo apt-get install postfix
sudo apt-get install mailutils

###################### Network ######################
mv /etc/network/interfaces /etc/network/interfaces.old
mv interfaces /etc/network/interfaces
sudo service networking restart
ifdown $NAMENET
ifup $NAMENET

###################### SSH ######################
mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old
mv sshd_config /etc/ssh/sshd_config
sudo service ssh restart
