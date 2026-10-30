#!/usr/bin/env bash
# -----------------------------------------------------
# AETHER Dark Void Purple - Quick Settings: Wi-Fi
# Native Rofi overlay matching Cliphist UI
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

while IFS= read -r line; do
    [ -z "$line" ] && continue
    in_use=$(echo "$line" | cut -d: -f1)
    ssid=$(echo "$line" | cut -d: -f2)
    signal=$(echo "$line" | cut -d: -f3)
    security=$(echo "$line" | cut -d: -f4-)
    
    [ -z "$ssid" ] && continue

    if [ "$in_use" = "*" ]; then
        icon="󰤨"
        label="✓ $icon  $ssid  ($signal% | $security) [Connected]"
    else
        if [ "$signal" -ge 70 ]; then
            icon="󰤨"
        elif [ "$signal" -ge 40 ]; then
            icon="󰤥"
        else
            icon="󰤟"
        fi
        label="  $icon  $ssid  ($signal% | $security)"
    fi
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
        nmcli device wifi rescan
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
        # Extract selected SSID
        clean_ssid=$(echo "$chosen" | sed 's/^[^A-Za-z0-9]*//' | awk '{print $1}')
        # Match from raw list if SSID had spaces
        matched_ssid=""
        while IFS= read -r line; do
            cur_ssid=$(echo "$line" | cut -d: -f2)
            if [[ "$chosen" == *"$cur_ssid"* && -n "$cur_ssid" ]]; then
                matched_ssid="$cur_ssid"
                break
            fi
        done <<< "$raw_list"

        [ -z "$matched_ssid" ] && matched_ssid="$clean_ssid"
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
                password=$(rofi -dmenu -password -config ~/.config/rofi/config-quicksettings.rasi -p "Key for $matched_ssid")
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
