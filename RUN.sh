#! /bin/bash

echo "[ \033[32mOK\033[0m ]\tRUN.sh start."
sleep 2

###################### Add User ######################
read -p "Choose username for new user: " username
sudo adduser $username
sudo usermod -aG sudo $username
echo "[ \033[32mOK\033[0m ]\tNew user add to sudo group."
sleep 3

###################### Start update and install package ######################
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install net-tools
sudo apt-get install iptables-persistent
sudo apt-get install nano
sudo apt-get install postfix
sudo apt-get install mailutils
sudo apt-get install fail2ban
sudo apt-get install openssl
echo "[ \033[32mOK\033[0m ]\tOS and packages udapte."
sleep 3

###################### Network ######################
NAMENET=$(netstat -i | grep "enp*" | cut -f1 -d " ")
sudo mv /etc/network/interfaces /etc/network/interfaces.old
sudo mv interfaces /etc/network/
sudo service networking restart
sudo ifdown $NAMENET
sudo ifup $NAMENET
echo "[ \033[32mOK\033[0m ]\tNetworking configuration and static IP."
sleep 3

###################### SSH ######################
sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.old
sudo mv sshd_config /etc/ssh/
sudo service ssh restart
echo "[ \033[32mOK\033[0m ]\tSSH configuration."
sleep 3

###################### Install scripts ######################
sudo mkdir /var/scripts/
sudo mv alert.sh /var/scripts/
sudo mv update.sh /var/scripts/
sudo mv /etc/crontab /etc/crontab.old
sudo mv crontab /etc/
echo "[ \033[32mOK\033[0m ]\tScripts udapte and alert installed."
sleep 3

###################### Mail ######################
sudo mv /etc/aliases /etc/aliases.old
sudo mv aliases /etc/
sudo newaliases
sudo mv /etc/postfix/main.cf /etc/postfix/main.cf.old
sudo mv main.cf /etc/postfix/
sudo mv virtual /etc/postfix/
sudo service postfix restart
echo "[ \033[32mOK\033[0m ]\tMail service configured."
sleep 3

###################### Iptables ######################
#sudo mv rules.v4 /etc/iptables/
#sudo mv rules.v6 /etc/iptables/
#sudo service netfilter-persistent restart
echo "[ \033[32mOK\033[0m ]\tIptables rules added."
sleep 3

###################### Fail2Ban ######################
sudo mv jail.local /etc/fail2ban/
sudo service fail2ban restart
echo "[ \033[32mOK\033[0m ]\tFail2Ban configured."
sleep 3

###################### Website ######################
sudo mv /var/www/html /var/www/html.old
sudo mv html /var/www/
echo "[ \033[32mOK\033[0m ]\tWebsite upload."
sleep 3

###################### SSL ######################
sudo mkdir -p /etc/ssl/localcerts
sudo openssl req -new -x509 -days 365 -nodes -out /etc/ssl/localcerts/apache.pem -keyout /etc/ssl/localcerts/apache.key
sudo chmod 600 /etc/ssl/localcerts/apache*
sudo a2enmod ssl
sudo mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.old
sudo mv default-ssl.conf /etc/apache2/sites-available/
sudo mv website.conf /etc/apache2/sites-available/
sudo service apache2 restart
echo "[ \033[32mOK\033[0m ]\tSSL configured."
sleep 3

###################### Finish ######################
echo "Installation finished."
echo "Reboot in 5 secondes"
sleep 1
echo "Reboot in 4 secondes"
sleep 1
echo "Reboot in 3 secondes"
sleep 1
echo "Reboot in 2 secondes"
sleep 1
echo "Reboot in 1 secondes"
sleep 1
sudo shutdown -r now
