#!/bin/bash

cd
if ! screen -list | grep -q "wss-one_ws-g"; then
    screen -dmS wss-one_ws-g rclone sync --local-no-check-updated --drive-acknowledge-abuse --progress --checksum --metadata wss-onedrive: ws-gdrive:
fi

exit 0