#!/bin/bash

[ -d '/root/idena' ] && (
    pm2 stop idena
    rm -rf /root/idena/datadir/logs
    rm -rf /root/idena/datadir/ipfs
    # rm -rf /root/idena/datadir/idenachain.db/*
    rm -rf /root/idena/datadir/idenachain.db
    # cd /root/idena/datadir/idenachain.db
    cd /root/idena/datadir/
    #wget https://sync.idena-ar.com/idenachain.db.zip
    #wget https://sync.idena.site/idenachain.db.zip
    wget https://github.com/ltraveler/idenachain.db/archive/refs/heads/main.zip -O /root/idena/datadir/
    unzip /root/idena/datadir/main.zip
    rm -rf /root/idena/datadir/main.zip
    mv -f /root/idena/datadir/idenachain.db/idenachain.db-main /root/idena/datadir/idenachain.db
    # unzip idenachain.db.zip
    # rm -rf idenachain.db.zip
    cd
    /root/idena.sh
)

exit 0