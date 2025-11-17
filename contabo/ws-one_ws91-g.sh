#!/bin/bash

cd
if ! screen -list | grep -q "ws-one_ws91-g"; then
    screen -dmS ws-one_ws91-g rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum ws-onedrive: ws91-gdrive:
fi

exit 0