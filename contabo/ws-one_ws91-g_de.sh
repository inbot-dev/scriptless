#!/bin/bash

cd
if ! screen -list | grep -q "ws-one_ws91-g"; then
    screen -dmS ws-one_ws91-g_de rclone dedupe --by-hash --dedupe-mode newest ws91-gdrive:
fi

exit 0