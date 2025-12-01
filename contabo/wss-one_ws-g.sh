#!/bin/bash

cd
if ! screen -list | grep -q "wss-one_ws-g"; then
    if ! screen -list | grep -q "wss-one_ws-g_de"; then
        screen -dmS wss-one_ws-g_de rclone dedupe --by-hash --dedupe-mode newest wss-onedrive:
    
        # Wait for the dedupe screen session to close
        while screen -list | grep -q "wss-one_ws-g_de"; do
            sleep 5
        done

        screen -dmS wss-one_ws-g rclone sync --local-no-check-updated --drive-acknowledge-abuse --progress --checksum --S2 --metadata wss-onedrive: ws-gdrive:
    fi
fi

exit 0