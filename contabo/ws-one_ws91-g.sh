#!/bin/bash

cd
if ! screen -list | grep -q "ws-one_ws91-g"; then
    screen -dmS ws-one_ws91-g_de rclone dedupe --by-hash --dedupe-mode newest ws91-gdrive:
    screen -dmS ws-one_ws91-g rclone sync --local-no-check-updated --drive-acknowledge-abuse --progress --checksum --metadata ws-onedrive: ws91-gdrive:
fi

exit 0