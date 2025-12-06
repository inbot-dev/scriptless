#!/bin/bash

apt-get update
apt-get upgrade -y
pm2 restart notif

cd

# curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Vultr Mulai"

mkdir -p /root/gd_bu
chmod +x /root/gd_bu

[ -d '/root/gunbot.my.id' ] && (
    # curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Folder Core Gunbot Mulai"
    mkdir -p /root/gd_bu/gunbot.my.id
    chmod +x /root/gd_bu/gunbot.my.id
    \cp -avrf /root/gunbot.my.id/* /root/gd_bu/gunbot.my.id/
    rm -rf /root/gd_bu/gunbot.my.id/node_modules
    zip -r /root/gd_bu/gunbot.my.id.zip /root/gd_bu/gunbot.my.id
    mkdir -p /root/bekap_json/
    chmod +x /root/bekap_json/
    mkdir -p /root/bekap_json/gunbot.my.id
    chmod +x /root/bekap_json/gunbot.my.id
    \cp -avrf /root/gunbot.my.id/json/* /root/bekap_json/gunbot.my.id/
    # curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Folder Core Gunbot Selesai"
)

[ -d '/root/bitrage.gunbot.my.id' ] && (
    # curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Folder Bitrage Gunbot Mulai"
    mkdir -p /root/gd_bu/bitrage.gunbot.my.id
    chmod +x /root/gd_bu/bitrage.gunbot.my.id
    \cp -avrf /root/bitrage.gunbot.my.id/* /root/gd_bu/bitrage.gunbot.my.id/
    zip -r /root/gd_bu/bitrage.gunbot.my.id.zip /root/gd_bu/bitrage.gunbot.my.id
    mkdir -p /root/bekap_json/
    chmod +x /root/bekap_json/
    mkdir -p /root/bekap_json/bitrage.gunbot.my.id
    chmod +x /root/bekap_json/bitrage.gunbot.my.id
    \cp -avrf /root/bitrage.gunbot.my.id/json/* /root/bekap_json/bitrage.gunbot.my.id/
    # curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Folder Bitrage Gunbot Selesai"
)

[ -d '/root/tools' ] && (
    # curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Folder Tools Mulai"
    mkdir -p /root/gd_bu/tools
    chmod +x /root/gd_bu/tools
    \cp -avrf /root/tools/* /root/gd_bu/tools/
    zip -r /root/gd_bu/tools.zip /root/gd_bu/tools
    # curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Folder Tools Selesai"
)

[ -d '/root/idena'] && (
    # curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Idena Mulai"
    mkdir -p /root/gd_bu/idena
    chmod +x /root/gd_bu/idena
    \cp -avrf /root/idena/* /root/gd_bu/idena/
    zip -r /root/gd_bu/idena.zip /root/gd_bu/idena
    # curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Idena Selesai"
)

# curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Semua Vultr Config RClone Mulai"
mkdir -p /root/gd_bu/.config
chmod +x /root/gd_bu/.config
\cp -avrf /root/.config/* /root/gd_bu/.config/
zip -r /root/gd_bu/.config.zip /root/gd_bu/.config
# curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Semua Vultr Config RClone Selesai"

# curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Semua Vultr File SH Mulai"
mkdir -p /root/gd_bu/.sh
chmod +x /root/gd_bu/.sh
\cp -avrf /root/*.sh /root/gd_bu/.sh/
zip -r /root/gd_bu/.sh.zip /root/gd_bu/.sh
# curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Semua Vultr File SH Selesai"

rclone sync --progress --drive-acknowledge-abuse --local-no-check-updated --checksum --metadata /root/gd_bu/ ws-onedrive:Server/Backup/Vultr

rm -rf /root/bekap_json/
rm -rf /root/gd_bu

# curl -s -X POST https://api.telegram.org/bot1899238854:AAH0tUYroXQLLmDw-sED2lzlE-ao2UpUbzM/sendMessage -d chat_id=277081400 -d text="Backup Vultr Selesai"

sudo apt update
sudo apt upgrade -y
[ -f /var/run/reboot-required ] && reboot

exit 0