#!/bin/bash

sudo apt-get update
sudo apt-get clean -y
[ -e '/etc/needrestart/needrestart.conf' ] && (printf "\n\$nrconf{restart} = 'a';" >> /etc/needrestart/needrestart.conf)
wget https://software.virtualmin.com/gpl/scripts/virtualmin-install.sh
sudo sh virtualmin-install.sh -f -v
rm -rf virtualmin-install.sh virtualmin-install.log update.txt
sudo apt-get update
sudo apt-get clean -y
sudo apt-get install -y wget curl unzip zip screen iptables fail2ban git fontconfig rar dos2unix
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
apt install -y python3-pip
sudo apt install -y python-is-python3
pip install gdown
sudo apt-get install -y build-essential
printf 'enter' | sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get clean -y
sudo apt-get install -y php8.4
sudo apt install php8.2-common php8.4-mysql php8.4-xml php8.4-xmlrpc php8.4-curl php8.4-gd php8.4-imagick php8.4-cli php8.4-dev php8.4-imap php8.4-mbstring php8.4-opcache php8.4-soap php8.4-zip php8.4-intl -y
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
sudo swapoff -a
fallocate -l 20GB /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
sudo apt-get clean -y
echo "" >> /etc/crontab
echo "@daily root sudo apt-get update" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root /root/bekap_r.sh" >> /etc/crontab
echo "" >> /etc/crontab
echo "@daily root pm2 restart notif" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * root sudo ntpdate -s time.nist.gov" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * root /root/idena.sh" >> /etc/crontab
echo "" >> /etc/crontab
echo "* * * * * root [ -f /var/run/reboot-required ] && reboot" >> /etc/crontab
chmod +x /etc/fail2ban/jail.local
printf "[DEFAULT]\nignoreip = 127.0.0.1/89\n\n[sshd]\nenable = true\nport = ssh\nfilter = sshd\nlogpath = /var/log/auth.log\nmaxretry = 4\nbantime = 1d\nignoreip = 127.0.0.1\n\n[myjail]\nenabled = true\nport = 80,8080,443,22,10000\nmaxretry = 6\nbantime = 1d">>/etc/fail2ban/jail.local
systemctl enable fail2ban.service
systemctl start fail2ban
source ~/.bashrc
command
sudo apt autoremove -y
sudo apt-get update
sudo apt-get clean -y
mkdir -p /root/gunbot.my.id
wget https://gunthy.org/downloads/gunthy_linux.zip -P /root/gunbot.my.id
cd /root/gunbot.my.id
unzip /root/gunbot.my.id/gunthy_linux.zip -d /root/gunbot.my.id
cd /root/gunbot.my.id
rm -rf config-js-example.txt
rm -rf gunthy_linux.zip __MACOSX
cd
chmod +x gunbot.my.id
chmod +x /root/gunbot.my.id/gunthy-linux
\cp -avrf /root/gunbot.my.id /root/bitrage.gunbot.my.id
sudo apt autoremove -y
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests
service apache2 restart
cd
cd /root/tools
pm2 start notif.js --name=notif --node-args="--max-old-space-size=8192"
pm2 stop notif
cd /root/gunbot.my.id
pm2 start gunthy-linux --name=gunbot
pm2 stop gunbot
pm2 save --force

exit 0