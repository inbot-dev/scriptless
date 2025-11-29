#!/bin/bash

cd
if ! screen -list | grep -q "ws-one_nxt"; then
    screen -dmS ws-one_nxt_de rclone dedupe --by-hash --dedupe-mode newest nxt:
fi

exit 0