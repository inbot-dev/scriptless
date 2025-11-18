#!/bin/bash

cd
if ! screen -list | grep -q "wss-one_ws-g"; then
    screen -dmS wss-one_ws-g_de rclone dedupe --by-hash --dedupe-mode newest wss-onedrive:
fi

exit 0