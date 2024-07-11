#!/usr/bin/env bash

if ! playerctl -p spotify status &> /dev/null; then
    echo ""
    exit 0
fi

ARTIST=$(playerctl -p spotify metadata artist)
TITLE=$(playerctl -p spotify metadata title)

echo "$ARTIST - $TITLE"
exit 0
