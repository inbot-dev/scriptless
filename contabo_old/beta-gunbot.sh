#!/bin/bash

cd

wget https://gunthy.org/downloads/beta/gunthy-linux.zip
unzip gunthy-linux.zip

[ -d '/root/gunbot.my.id' ] && (
    pm2 stop gunbot
    pm2 flush gunbot
    rm -rf /root/gunbot.my.id/gunthy-linux
    \cp -avrf /root/gunthy-linux /root/gunbot.my.id/
    pm2 restart gunbot
)

[ -d '/root/bitrage.gunbot.my.id' ] && (
    pm2 stop bitrage-gunbot
    pm2 flush bitrage-gunbot
    rm -rf /root/bitrage.gunbot.my.id/gunthy-linux
    \cp -avrf /root/gunthy-linux /root/bitrage.gunbot.my.id/
    pm2 restart bitrage-gunbot
)

rm -rf /root/gunthy-linux /root/gunthy-linux.zip /root/gunthy-linux

exit 0