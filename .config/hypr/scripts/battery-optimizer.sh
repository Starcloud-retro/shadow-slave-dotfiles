#!/usr/bin/env bash
# -----------------------------------------------------
# AETHER Battery Optimization Daemon
# Dynamic Power-Saver & Compositor Resource Scaler
# -----------------------------------------------------

last_state=""

apply_battery_profile() {
    powerprofilesctl set power-saver 2>/dev/null
    
    # Optimize Hyprland rendering for GPU power efficiency
    hyprctl keyword decoration:blur:enabled false >/dev/null 2>&1
    hyprctl keyword decoration:shadow:enabled false >/dev/null 2>&1
    
    # Cap excessive brightness to save display panel power
    cur_bright=$(/home/aetheon-star/.local/bin/brightnessctl -m 2>/dev/null | awk -F, '{print $4}' | tr -d '%')
    if [ -n "$cur_bright" ] && [ "$cur_bright" -gt 50 ]; then
        /home/aetheon-star/.local/bin/brightnessctl set 40% >/dev/null 2>&1
    fi
    
    notify-send -u low -i battery-low "Battery Mode Activated" "Switched to Power-Saver profile. GPU blur/shadows disabled to extend battery." 2>/dev/null
}

apply_ac_profile() {
    powerprofilesctl set balanced 2>/dev/null
    
    # Restore full Dark Void glass aesthetics
    hyprctl keyword decoration:blur:enabled true >/dev/null 2>&1
    hyprctl keyword decoration:shadow:enabled true >/dev/null 2>&1
    
    notify-send -u low -i battery-charging "AC Power Connected" "Performance restored. Blur, shadows & balanced profile active." 2>/dev/null
}

# Main polling loop
while true; do
    bat_state=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 2>/dev/null | grep -E "state:" | awk '{print $2}')
    
    if [ "$bat_state" != "$last_state" ]; then
        if [ "$bat_state" = "discharging" ]; then
            apply_battery_profile
        elif [ "$bat_state" = "charging" ] || [ "$bat_state" = "fully-charged" ]; then
            apply_ac_profile
        fi
        last_state="$bat_state"
    fi
    sleep 15
done
