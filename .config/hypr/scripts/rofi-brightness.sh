#!/usr/bin/env bash
# -----------------------------------------------------
# AETHER Dark Void Purple - Quick Settings: Brightness & Keyboard Backlight
# Standardized clean presets matching Cliphist UI
# -----------------------------------------------------

export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"

cur_screen=$(~/.local/bin/brightnessctl -m 2>/dev/null | awk -F, '{print $4}' | tr -d '%')
[ -z "$cur_screen" ] && cur_screen=50

cur_kbd=$(~/.local/bin/brightnessctl --device='dell::kbd_backlight' get 2>/dev/null)
case "$cur_kbd" in
    2) kbd_status="100%" ;;
    1) kbd_status="50%" ;;
    *) kbd_status="OFF" ;;
esac

menu="󰃠  Screen: 100% (Full)\n󰃟  Screen: 75% (High)\n󰃟  Screen: 50% (Balanced)\n󰃞  Screen: 25% (Dim)\n⌨  Keyboard: 100% (High)\n⌨  Keyboard: 50% (Medium)\n⌨  Keyboard: OFF"

chosen=$(echo -e "$menu" | rofi -dmenu -i -config ~/.config/rofi/config-quicksettings.rasi -p "Display [${cur_screen}%] | Kbd [${kbd_status}]")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Screen: 100%"*)
        ~/.local/bin/brightnessctl set 100% >/dev/null
        notify-send -u low -i display-brightness "Display Brightness" "Set to 100%"
        ;;
    *"Screen: 75%"*)
        ~/.local/bin/brightnessctl set 75% >/dev/null
        notify-send -u low -i display-brightness "Display Brightness" "Set to 75%"
        ;;
    *"Screen: 50%"*)
        ~/.local/bin/brightnessctl set 50% >/dev/null
        notify-send -u low -i display-brightness "Display Brightness" "Set to 50%"
        ;;
    *"Screen: 25%"*)
        ~/.local/bin/brightnessctl set 25% >/dev/null
        notify-send -u low -i display-brightness "Display Brightness" "Set to 25%"
        ;;
    *"Keyboard: 100%"*)
        ~/.local/bin/brightnessctl --device='dell::kbd_backlight' set 2 >/dev/null
        notify-send -u low -i keyboard-brightness "Keyboard Backlight" "Set to 100% (High)"
        ;;
    *"Keyboard: 50%"*)
        ~/.local/bin/brightnessctl --device='dell::kbd_backlight' set 1 >/dev/null
        notify-send -u low -i keyboard-brightness "Keyboard Backlight" "Set to 50% (Medium)"
        ;;
    *"Keyboard: OFF"*)
        ~/.local/bin/brightnessctl --device='dell::kbd_backlight' set 0 >/dev/null
        notify-send -u low -i keyboard-brightness "Keyboard Backlight" "Turned OFF"
        ;;
esac
