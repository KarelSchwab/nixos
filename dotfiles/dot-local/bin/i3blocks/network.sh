#!/usr/bin/env bash

IF="${IFACE:-$BLOCK_INSTANCE}"

# Exit if no interface is specified
if [[ -z "$IF" ]]; then
    echo "Not connected"
    exit 0
fi

IF="${IF:-$(ip route | awk '/^default/ { print $5 ; exit }')}"

# Exit if there is no default route
if [[ -z "$IF" ]]; then
    echo "Not connected"
    exit 0
fi

IP_ADDR=$(ip a show "$IF" | awk '/inet /{ print $2 }' | cut -d '/' -f 1)

echo "$IP_ADDR"
