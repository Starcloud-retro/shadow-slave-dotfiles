#!/usr/bin/env bash
# -----------------------------------------------------
# AETHER Dramatic Power Menu
# Cinematic 5-card interactive power action dialog
# -----------------------------------------------------

export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"

cards="⏻  Shutdown\n  Reboot\n󰤄  Suspend\n󰌾  Lock\n󰍃  Logout"

chosen=$(echo -e "$cards" | rofi -dmenu -i -config ~/.config/rofi/config-power.rasi -p "")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Shutdown"*) $HOME/.config/hypr/scripts/power.sh shutdown ;;
    *"Reboot"*)   $HOME/.config/hypr/scripts/power.sh reboot ;;
    *"Suspend"*)  $HOME/.config/hypr/scripts/power.sh suspend ;;
    *"Lock"*)     $HOME/.config/hypr/scripts/power.sh lock ;;
    *"Logout"*)   $HOME/.config/hypr/scripts/power.sh exit ;;
esac
