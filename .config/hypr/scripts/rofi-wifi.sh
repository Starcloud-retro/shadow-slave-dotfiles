#!/usr/bin/env bash
# -----------------------------------------------------
# AETHER Dark Void Purple - Quick Settings: Wi-Fi
# Native Rofi overlay with smooth scrolling and robust selection
# -----------------------------------------------------

export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"

wifi_state=$(nmcli -t -f WIFI g)

if [ "$wifi_state" = "disabled" ]; then
    chosen=$(printf "󰤨  Enable Wi-Fi\n󰅖  Cancel" | rofi -dmenu -i -config ~/.config/rofi/config-quicksettings.rasi -p "Wi-Fi [OFF]")
    if [ "$chosen" = "󰤨  Enable Wi-Fi" ]; then
        nmcli radio wifi on
        notify-send -u normal -i network-wireless "Wi-Fi" "Wi-Fi enabled"
    fi
    exit 0
fi

# Get current connected SSID if any
active_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2-)

menu_items="󰤮  Disable Wi-Fi\n󰑐  Rescan Networks"

# Scan networks
raw_list=$(nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list)

declare -A seen_ssids

# If connected, list active network at top
if [ -n "$active_ssid" ]; then
    menu_items="${menu_items}\n✓ 󰤨  ${active_ssid}  [Connected]"
    seen_ssids["$active_ssid"]=1
fi

while IFS= read -r line; do
    [ -z "$line" ] && continue
    in_use=$(echo "$line" | cut -d: -f1)
    ssid=$(echo "$line" | cut -d: -f2)
    signal=$(echo "$line" | cut -d: -f3)
    security=$(echo "$line" | cut -d: -f4-)
    
    [ -z "$ssid" ] && continue
    [ "${seen_ssids[$ssid]}" = "1" ] && continue
    seen_ssids["$ssid"]=1

    if [ "$signal" -ge 70 ]; then
        icon="󰤨"
    elif [ "$signal" -ge 40 ]; then
        icon="󰤥"
    else
        icon="󰤟"
    fi
    label="  $icon  $ssid  ($signal% | $security)"
    menu_items="${menu_items}\n${label}"
done <<< "$raw_list"

chosen=$(echo -e "$menu_items" | rofi -dmenu -i -config ~/.config/rofi/config-quicksettings.rasi -p "Wi-Fi Networks")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Disable Wi-Fi"*)
        nmcli radio wifi off
        notify-send -u normal -i network-wireless-offline "Wi-Fi" "Wi-Fi disabled"
        ;;
    *"Rescan Networks"*)
        notify-send -u normal -i network-wireless "Wi-Fi" "Scanning for networks..."
        nmcli device wifi rescan
        sleep 1
        exec "$0"
        ;;
    *"[Connected]"*)
        action=$(printf "󰅖  Disconnect from $active_ssid\n󰑐  Cancel" | rofi -dmenu -i -config ~/.config/rofi/config-quicksettings.rasi -p "Active Connection")
        if [[ "$action" =~ "Disconnect" ]]; then
            nmcli device disconnect wlan0 2>/dev/null || nmcli connection down "$active_ssid"
            notify-send -u normal -i network-wireless-disconnected "Wi-Fi" "Disconnected from $active_ssid"
        fi
        ;;
    *)
        # Extract selected SSID using reliable regex
        matched_ssid=$(python3 -c "
import re, sys
s = '''$chosen'''
m = re.search(r'^\s*(?:✓\s*)?[^\s]+\s+(.+?)\s+\(\d+%', s)
if m:
    print(m.group(1).strip())
elif '[Connected]' in s:
    m2 = re.search(r'^\s*(?:✓\s*)?[^\s]+\s+(.+?)\s+\[Connected\]', s)
    if m2: print(m2.group(1).strip())
")

        [ -z "$matched_ssid" ] && exit 0

        # Check if already saved in NetworkManager connections
        if nmcli -t -f NAME connection show | grep -Fxq "$matched_ssid"; then
            notify-send -u normal -i network-wireless "Connecting..." "Connecting to saved network $matched_ssid"
            if nmcli connection up "$matched_ssid"; then
                notify-send -u normal -i network-wireless "Wi-Fi" "Successfully connected to $matched_ssid"
            else
                notify-send -u critical -i network-wireless-error "Wi-Fi" "Failed to connect to $matched_ssid"
            fi
        else
            # Check if network is password protected
            if echo "$chosen" | grep -Eq "WPA|WEP|802.1x"; then
                password=$(rofi -dmenu -password -config ~/.config/rofi/config-quicksettings.rasi -p "Password for $matched_ssid")
                [ -z "$password" ] && exit 0
                notify-send -u normal -i network-wireless "Connecting..." "Connecting to $matched_ssid"
                if nmcli device wifi connect "$matched_ssid" password "$password"; then
                    notify-send -u normal -i network-wireless "Wi-Fi" "Successfully connected to $matched_ssid"
                else
                    notify-send -u critical -i network-wireless-error "Wi-Fi" "Failed to connect. Check password."
                fi
            else
                nmcli device wifi connect "$matched_ssid"
                notify-send -u normal -i network-wireless "Wi-Fi" "Connected to open network $matched_ssid"
            fi
        fi
        ;;
esac
