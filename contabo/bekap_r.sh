#!/bin/bash

cd
if ! screen -list | grep -q "bekap"; then
    screen -dmS bekap ./bekap.sh
fi

exit 0