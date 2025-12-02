#!/bin/bash

cd
if ! screen -list | grep -q "ws_work_wss-one"; then
    if ! screen -list | grep -q "ws_work_wss-one_de"; then
        screen -dmS ws_work_wss-one_de rclone dedupe --by-hash --dedupe-mode newest ws-onedrive_work:IE/S2

        # Wait for the dedupe screen session to close
        while screen -list | grep -q "ws_work_wss-one_de"; do
            sleep 5
        done

        screen -dmS ws_work_wss-one rclone sync --local-no-check-updated --drive-acknowledge-abuse --progress --checksum --metadata ws-onedrive_work:IE ws-onedrive:
    fi
fi

exit 0