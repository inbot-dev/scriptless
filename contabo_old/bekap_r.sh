#!/bin/bash

cd
if ! screen -list | grep -q "bekap"; then
    screen -dmSL bekap ./bekap.sh
fi

exit 0