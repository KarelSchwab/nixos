#!/usr/bin/env bash

if playerctl -p spotify status &> /dev/null; then
    ARTIST=$(playerctl -p spotify metadata artist)
    TITLE=$(playerctl -p spotify metadata title)

    echo "$ARTIST - $TITLE"
    exit 0
fi

if playerctl -p brave status &> /dev/null; then
    ARTIST=$(playerctl -p brave metadata artist)
    TITLE=$(playerctl -p brave metadata title)

    echo "$ARTIST - $TITLE"
    exit 0
fi

echo ""
exit 0
