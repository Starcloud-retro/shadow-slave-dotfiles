#!/bin/bash
killall waybar 2>/dev/null
killall swaybg 2>/dev/null
pkill -f gothic_clock.py 2>/dev/null

# 1. Dark Void Shadow Slave Wallpaper
swaybg -i "/home/aetheon-star/Pictures/Shadow Slave_ Stormlit Citadel.png" -m fill &

# 2. Waybar Glass Panel
~/.config/waybar/launch.sh &
