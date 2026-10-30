#!/usr/bin/env bash
# -----------------------------------------------------
# AETHER Dark Void Purple - Quick Settings: Bluetooth
# Native Rofi overlay matching Cliphist UI
# -----------------------------------------------------

export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"

bt_powered=$(bluetoothctl show | grep -i "Powered:" | awk '{print $2}')

if [ "$bt_powered" != "yes" ]; then
    chosen=$(printf "󰂯  Turn Bluetooth ON\n󰅖  Cancel" | rofi -dmenu -i -config ~/.config/rofi/config-quicksettings.rasi -p "Bluetooth [OFF]")
    if [ "$chosen" = "󰂯  Turn Bluetooth ON" ]; then
        bluetoothctl power on
        notify-send -u normal -i bluetooth "Bluetooth" "Bluetooth powered ON"
    fi
    exit 0
fi

menu_items="󰂲  Turn Bluetooth OFF\n󰑐  Scan for Devices"

# Get paired devices
devices_raw=$(bluetoothctl devices)
info_raw=$(bluetoothctl info 2>/dev/null)

while IFS= read -r dev; do
    [ -z "$dev" ] && continue
    mac=$(echo "$dev" | awk '{print $2}')
    name=$(echo "$dev" | cut -d' ' -f3-)

    # Check if connected
    if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
        menu_items="${menu_items}\n✓ 󰂱  $name  ($mac) [Connected]"
    else
        menu_items="${menu_items}\n  󰂯  $name  ($mac) [Paired]"
    fi
done <<< "$devices_raw"

chosen=$(echo -e "$menu_items" | rofi -dmenu -i -config ~/.config/rofi/config-quicksettings.rasi -p "Bluetooth Devices")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Turn Bluetooth OFF"*)
        bluetoothctl power off
        notify-send -u normal -i bluetooth-disabled "Bluetooth" "Bluetooth powered OFF"
        ;;
    *"Scan for Devices"*)
        notify-send -u normal -i bluetooth "Bluetooth" "Scanning for nearby devices (5 seconds)..."
        bluetoothctl --timeout 5 scan on
        exec "$0"
        ;;
    *"[Connected]"*)
        mac=$(echo "$chosen" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
        action=$(printf "󰅖  Disconnect Device\n󰆴  Unpair / Forget\n󰑐  Cancel" | rofi -dmenu -i -config ~/.config/rofi/config-quicksettings.rasi -p "Manage Device")
        if [[ "$action" =~ "Disconnect" ]]; then
            bluetoothctl disconnect "$mac"
            notify-send -u normal -i bluetooth "Bluetooth" "Disconnected device"
        elif [[ "$action" =~ "Unpair" ]]; then
            bluetoothctl remove "$mac"
            notify-send -u normal -i bluetooth "Bluetooth" "Device removed"
        fi
        ;;
    *"[Paired]"*)
        mac=$(echo "$chosen" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
        notify-send -u normal -i bluetooth "Bluetooth" "Connecting to $mac..."
        if bluetoothctl connect "$mac"; then
            notify-send -u normal -i bluetooth "Bluetooth" "Successfully connected"
        else
            notify-send -u critical -i bluetooth "Bluetooth" "Failed to connect"
        fi
        ;;
    *)
        mac=$(echo "$chosen" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
        if [ -n "$mac" ]; then
            bluetoothctl pair "$mac"
            bluetoothctl connect "$mac"
        fi
        ;;
esac
