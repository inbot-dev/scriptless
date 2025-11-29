#!/bin/bash

cd
if ! screen -list | grep -q "ws-one_nxt"; then
    screen -dmS ws-one_nxt rclone sync --local-no-check-updated --drive-acknowledge-abuse --progress --checksum --metadata ws-onedrive: nxt:

fi

exit 0