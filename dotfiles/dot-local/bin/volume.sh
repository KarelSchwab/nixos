#!/usr/bin/env bash

function send_notification {
    volume=$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')
    dunstify -t 1000 -r 69420 -u normal -h int:value:"$volume" "Volume: $volume%"
}

case $1 in
    up)
        amixer -q set Master 10%+ unmute
        ;;
    down)
        amixer -q set Master 10%- unmute
        ;;
esac

send_notification
