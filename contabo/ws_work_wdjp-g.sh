#!/bin/bash

cd
if ! screen -list | grep -q "ws_work_wdjp-g"; then
    if ! screen -list | grep -q "ws_work_wdjp-g_de"; then
        screen -dmS ws_work_wdjp-g_de rclone dedupe --by-hash --dedupe-mode newest ws-onedrive_work:

        # Wait for the dedupe screen session to close
        while screen -list | grep -q "ws_work_wdjp-g_de"; do
            sleep 5
        done

        screen -dmS ws_work_wdjp-g rclone sync --local-no-check-updated --drive-acknowledge-abuse --progress --checksum --metadata ws-onedrive_work: wdjp-gdrive:
    fi
fi

exit 0