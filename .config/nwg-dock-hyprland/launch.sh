#!/usr/bin/env bash
killall nwg-dock-hyprland 2>/dev/null
sleep 0.3
nohup ~/.local/bin/nwg-dock-hyprland -d -hd 0 -i 48 -p bottom -a center -mb 14 -w 5 -s style.css -c "$HOME/.config/hypr/scripts/launcher.sh" >/dev/null 2>&1 &
