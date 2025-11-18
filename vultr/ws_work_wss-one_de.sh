#!/bin/bash

cd
if ! screen -list | grep -q "ws_work_wdjp-g"; then
    screen -dmS ws_work_wdjp-g_de rclone dedupe --by-hash --dedupe-mode newest ws-onedrive_work:
fi

exit 0