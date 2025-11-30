#!/bin/bash

cd
if ! screen -list | grep -q "ws_work_wss-one"; then
    screen -dmS ws_work_wss-one rclone sync --local-no-check-updated --drive-acknowledge-abuse --progress --checksum --metadata ws-onedrive_work:IE/S2 wdjp-gdrive:S2
fi

exit 0