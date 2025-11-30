#!/bin/bash

[ -d '/root/idena' ] && (
    cd /root/idena
    ver=$(curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep browser_download_url | grep idena-node-linux-* | head -n 1 | cut -d '"' -f 4 | cut -d '/' -f 9 | cut -d '-' -f 4)
    [ -n $ver ] && (
        if ! grep -q $ver /root/idena/vers.txt; then
            pm2 stop idena
            rm -rf /root/idena/vers.txt
            touch /root/idena/vers.txt
            cons=$ver
            echo $cons >> /root/idena/vers.txt
            rm -rf /root/idena/idena-go
            cd /root/idena
            curl -s https://api.github.com/repos/idena-network/idena-go/releases/latest | grep browser_download_url | grep idena-node-linux-* | head -n 1 | cut -d '"' -f 4 | wget -qi -
            mv idena-node-linux* idena-go
            chmod +x idena-go
            pm2 restart idena
        fi
    )
)

exit 0