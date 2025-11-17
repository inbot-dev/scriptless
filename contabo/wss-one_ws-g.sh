#!/bin/bash

cd
if ! screen -list | grep -q "wss-one_ws-g"; then
    screen -dmS wss-one_ws-g rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum wss-onedrive: ws-gdrive:
fi

exit 0