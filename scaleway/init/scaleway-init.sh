#!/bin/bash

sudo apt-get update
sudo apt-get clean -y
sudo apt-get install -y wget curl unzip zip nano ufw squid apache2-utils screen iptables fail2ban git fontconfig dos2unix squid apache2-utils
sudo apt update -y
sudo apt upgrade -y
sudo curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh
sudo bash setup-repos.sh
sudo apt install webmin --install-recommends -y
rm -rf setup-repos.sh
sudo apt-get update -y
sudo apt-get clean -y
sudo apt-get install -y wget curl unzip zip screen git fontconfig rar dos2unix
sudo apt-get update
sudo apt-get clean -y
sudo -v ; curl https://rclone.org/install.sh | sudo bash
sudo apt-get update
sudo apt-get clean -y
curl -fsSL https://deb.nodesource.com/setup_23.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install pm2@latest -g
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 20M
pm2 set pm2-logrotate:dateFormat DD-MM-YYYY_HH-mm-ss
pm2 set pm2-logrotate:TZ Asia/Jakarta
pm2 startup
pm2 save --force
sudo apt install -y software-properties-common
printf "enter" | sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get clean -y
sudo apt install -y python3.13
sudo apt install -y python3-pip
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1
# sudo apt install -y python-is-python3
pip install gdown
sudo apt-get install -y build-essential
printf 'enter' | sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get clean -y
sudo apt-get install -y php7.4
sudo apt install php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl -y
sudo apt-get update
sudo apt-get clean -y
sudo apt install ntpdate -y
sudo ntpdate -s time.nist.gov
sudo timedatectl set-timezone UTC
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
cd
sudo apt autoremove -y
sudo apt-get update
sudo apt-get clean -y
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests
a2dissite 000-default 
a2enmod proxy proxy_http rewrite headers expires
service apache2 restart
cd
mkdir -p /root/tools
cd /root/tools
pm2 start notifRec.js --name=notifRec --node-args="--max-old-space-size=8192"
pm2 stop notifRec
pm2 start notif.js --name=notif --node-args="--max-old-space-size=8192"
pm2 stop notif

exit 0