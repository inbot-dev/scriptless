#!/bin/bash

cd
if ! screen -list | grep -q "ws_work_wss-one"; then
    screen -dmS ws_work_wss-one rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum ws-onedrive_work:IE/S2 wdjp-gdrive:S2
fi

exit 0