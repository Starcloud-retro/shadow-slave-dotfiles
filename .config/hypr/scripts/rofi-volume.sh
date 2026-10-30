#!/usr/bin/env bash
# -----------------------------------------------------
# AETHER Dark Void Purple - Quick Settings: Audio & Volume
# Standardized clean presets matching Cliphist UI
# -----------------------------------------------------

export LANG="en_IN.UTF-8"
export LC_ALL="en_IN.UTF-8"

vol=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -o -E '[0-9]+%' | head -n 1 | tr -d '%')
[ -z "$vol" ] && vol=50

is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}')
if [ "$is_muted" = "yes" ]; then
    mute_label="  Unmute Audio (Currently Muted)"
else
    mute_label="  Mute Audio (Current: ${vol}%)"
fi

mic_muted=$(pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | awk '{print $2}')
if [ "$mic_muted" = "yes" ]; then
    mic_label="  Unmute Microphone"
else
    mic_label="  Mute Microphone"
fi

menu="${mute_label}\n  Volume: 100% (Full)\n  Volume: 75% (High)\n  Volume: 50% (Balanced)\n  Volume: 25% (Quiet)\n${mic_label}"

# Add active sinks
while IFS= read -r sink_line; do
    [ -z "$sink_line" ] && continue
    sink_num=$(echo "$sink_line" | awk '{print $1}')
    sink_name=$(echo "$sink_line" | awk '{print $2}')
    clean_name=$(echo "$sink_name" | sed 's/.*\.//' | sed 's/__sink//')
    
    if pactl get-default-sink 2>/dev/null | grep -q "$sink_name"; then
        menu="${menu}\n✓ 󰓃  Device: $clean_name [Active]"
    else
        menu="${menu}\n  󰓃  Switch to $clean_name"
    fi
done < <(pactl list short sinks 2>/dev/null)

menu="${menu}\n󰕾  Audio Control Panel"

chosen=$(echo -e "$menu" | rofi -dmenu -i -config ~/.config/rofi/config-quicksettings.rasi -p "Audio [${vol}%]")

[ -z "$chosen" ] && exit 0

case "$chosen" in
    *"Unmute Audio"*)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        notify-send -u low -i audio-volume-high "Volume" "Audio unmuted"
        ;;
    *"Mute Audio"*)
        pactl set-sink-mute @DEFAULT_SINK@ 1
        notify-send -u low -i audio-volume-muted "Volume" "Audio muted"
        ;;
    *"Volume: 100%"*)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 100%
        ;;
    *"Volume: 75%"*)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 75%
        ;;
    *"Volume: 50%"*)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 50%
        ;;
    *"Volume: 25%"*)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        pactl set-sink-volume @DEFAULT_SINK@ 25%
        ;;
    *"Unmute Microphone"*)
        pactl set-source-mute @DEFAULT_SOURCE@ 0
        notify-send -u low -i audio-input-microphone "Microphone" "Microphone unmuted"
        ;;
    *"Mute Microphone"*)
        pactl set-source-mute @DEFAULT_SOURCE@ 1
        notify-send -u low -i audio-input-microphone-muted "Microphone" "Microphone muted"
        ;;
    *"Switch to"*)
        target_token=$(echo "$chosen" | awk '{print $NF}')
        target_sink=$(pactl list short sinks | awk '{print $2}' | grep "$target_token" | head -n 1)
        if [ -n "$target_sink" ]; then
            pactl set-default-sink "$target_sink"
            notify-send -u low -i audio-card "Audio Device" "Switched output to $target_token"
        fi
        ;;
    *"Audio Control Panel"*)
        pavucontrol &
        ;;
esac
