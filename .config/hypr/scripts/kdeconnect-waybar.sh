#!/bin/bash
if ! command -v kdeconnect-cli &>/dev/null; then
    echo '{"text": "", "tooltip": "KDE Connect not installed", "class": "disconnected"}'
    exit 0
fi

device_id=$(kdeconnect-cli -a --id-only 2>/dev/null | head -n 1)
device_name=$(kdeconnect-cli -a --name-only 2>/dev/null | head -n 1)

if [ -n "$device_id" ]; then
    echo "{\"text\": \"\", \"tooltip\": \"KDE Connect: $device_name (Reachable)\", \"class\": \"connected\"}"
else
    echo '{"text": "", "tooltip": "KDE Connect: No Device Connected", "class": "disconnected"}'
fi
