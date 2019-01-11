#! /bin/bash

echo "[ \033[32mOK\033[0m ]\tAutomatized start."
sleep 2

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
sudo mv /etc/network/interfaces /etc/network/interfaces.old
sudo mv interfaces /etc/network/
sudo service networking restart
sudo ifdown $NAMENET
sudo ifup $NAMENET

###################### SSH ######################
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old
sudo mv sshd_config /etc/ssh/
sudo service ssh restart

###################### Install scripts ######################
sudo mkdir /var/scripts/
sudo mv alert.sh /var/scripts/
sudo mv update.sh /var/scripts/
sudo mv /etc/crontab /etc/crontab.old
sudo mv crontab /etc/

###################### Mail ######################
sudo mv /etc/aliases /etc/aliases.old
sudo mv aliases /etc/
sudo newaliases
sudo mv /etc/postfix/main.cf /etc/postfix/main.cf.old
sudo mv main.cf /etc/postfix/
sudo mv virtual /etc/postfix/
sudo service postfix restart

###################### Iptables ######################
#sudo mv rules.v4 /etc/iptables/
#sudo mv rules.v6 /etc/iptables/
#sudo service netfilter-persistent restart

###################### Fail2Ban ######################
sudo mv /etc/fail2ban/jail.local /etc/fail2ban/jail.local.old
sudo mv jail.local /etc/fail2ban/
sudo service restart fail2ban

###################### Website ######################
sudo mv /var/www/html /var/www/html.old
sudo mv html /var/www/

###################### Finish ######################

echo "[ \033[32mOK\033[0m ]\tNew user add to sudo group."
echo "[ \033[32mOK\033[0m ]\tOS and packages udapte."
echo "[ \033[32mOK\033[0m ]\tNetworking configuration and static IP."
echo "[ \033[32mOK\033[0m ]\tSSH configuration."
echo "[ \033[32mOK\033[0m ]\tScripts udapte and alert installed."
echo "[ \033[32mOK\033[0m ]\tMail service configured."
echo "[ \033[32mOK\033[0m ]\tIptables rules added."
echo "[ \033[32mOK\033[0m ]\tFail2Ban configured."
echo "[ \033[32mOK\033[0m ]\tWebsite upload."

sleep 2
