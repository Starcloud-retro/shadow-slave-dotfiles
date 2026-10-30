#!/usr/bin/env bash
#                    __
#  _    _____ ___ __/ /  ___ _____
# | |/|/ / _ `/ // / _ \/ _ `/ __/
# |__,__/\_,_/\_, /_.__/\_,_/_/
#            /___/
#

# -----------------------------------------------------
# Prevent duplicate launches: only the first parallel
# invocation proceeds; all others exit immediately.
# -----------------------------------------------------

exec 200>/tmp/waybar-launch.lock
flock -n 200 || exit 0

# -----------------------------------------------------
# Quit all running waybar instances
# -----------------------------------------------------

killall waybar || true
pkill waybar || true
sleep 0.5

# -----------------------------------------------------
# Default theme: /THEMEFOLDER;/VARIATION
# -----------------------------------------------------

default_theme="/ml4w-glass-center;/ml4w-glass-center/default"

# -----------------------------------------------------
# Remove incompatible themes
# -----------------------------------------------------

if [ -f ~/.config/ml4w/settings/waybar-theme.sh ]; then
    themestyle=$(cat ~/.config/ml4w/settings/waybar-theme.sh)
    case "$themestyle" in
    "/ml4w-modern;/ml4w-modern/light")
        echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
        ;;
    "/ml4w-modern;/ml4w-modern/dark")
        echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
        ;;
    "/ml4w;/ml4w/light")
        echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
        ;;
    "/ml4w;/ml4w/dark")
        echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
        ;;
    *)
        echo
        ;;
    esac
    if [ -d $HOME/.config/waybar/themes/ml4w-modern/light ]; then
        rm -rf $HOME/.config/waybar/themes/ml4w-modern/light
    fi
    if [ -d $HOME/.config/waybar/themes/ml4w-modern/dark ]; then
        rm -rf $HOME/.config/waybar/themes/ml4w-modern/dark
    fi
    if [ -d $HOME/.config/waybar/themes/ml4w/light ]; then
        rm -rf $HOME/.config/waybar/themes/ml4w/light
    fi
    if [ -d $HOME/.config/waybar/themes/ml4w/dark ]; then
        rm -rf $HOME/.config/waybar/themes/ml4w/dark
    fi
fi

# -----------------------------------------------------
# Get current theme information from ~/.config/ml4w/settings/waybar-theme.sh
# -----------------------------------------------------

if [ -f ~/.config/ml4w/settings/waybar-theme.sh ]; then
    themestyle=$(cat ~/.config/ml4w/settings/waybar-theme.sh)
else
    touch ~/.config/ml4w/settings/waybar-theme.sh
    echo "$default_theme" >~/.config/ml4w/settings/waybar-theme.sh
    themestyle=$default_theme
fi

IFS=';' read -ra arrThemes <<<"$themestyle"
echo ":: Theme: ${arrThemes[0]}"

if [ ! -f ~/.config/waybar/themes${arrThemes[1]}/style.css ]; then
    themestyle=$default_theme
fi

# -----------------------------------------------------
# Toggle Waybar modules
# -----------------------------------------------------

_toggle_module() {
    local module_name=$1
    local settings_file=$2
    local value=$(cat "$settings_file")
    local file="$HOME/.config/waybar/themes${arrThemes[0]}/config"
    if [ "$value" == "True" ]; then
        search_string=" \"$module_name\""
        if ! grep -qF "$search_string" "$file"; then
            sed -i "s| //\"$module_name\"| \"$module_name\"|g" "$file"
        fi    
    else
        search_string=" //\"$module_name\""
        if ! grep -qF "$search_string" "$file"; then
            sed -i "s| \"$module_name\"| //\"$module_name\"|g" "$file"
        fi    
    fi
}

_toggle_module "custom/appmenu" "$HOME/.config/ml4w/settings/waybar_appmenu.sh"
_toggle_module "wlr/taskbar" "$HOME/.config/ml4w/settings/waybar_taskbar.sh"
_toggle_module "group/quicklinks" "$HOME/.config/ml4w/settings/waybar_quicklinks.sh"
_toggle_module "hyprland/window" "$HOME/.config/ml4w/settings/waybar_window.sh"
_toggle_module "network" "$HOME/.config/ml4w/settings/waybar_network.sh"
_toggle_module "tray" "$HOME/.config/ml4w/settings/waybar_systray.sh"

# -----------------------------------------------------
# Loading the configuration
# -----------------------------------------------------

config_file="config"
style_file="style.css"

# Standard files can be overwritten with an existing config-custom or style-custom.css
if [ -f ~/.config/waybar/themes${arrThemes[0]}/config-custom ]; then
    config_file="config-custom"
fi
if [ -f ~/.config/waybar/themes${arrThemes[1]}/style-custom.css ]; then
    style_file="style-custom.css"
fi

# Check if waybar-disabled file exists
if [ ! -f $HOME/.config/ml4w/settings/waybar-disabled ]; then
    # Ensure Hyprland IPC socket is detected before starting Waybar
    for i in {1..25}; do
        if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && [ -S "/run/user/$(id -u)/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock" ]; then
            break
        fi
        sig=$(ls -1 /run/user/$(id -u)/hypr/ 2>/dev/null | grep -v "\.sock" | head -n 1)
        if [ -n "$sig" ] && [ -S "/run/user/$(id -u)/hypr/$sig/.socket.sock" ]; then
            export HYPRLAND_INSTANCE_SIGNATURE="$sig"
            break
        fi
        sleep 0.2
    done

    setsid nohup waybar -c ~/.config/waybar/themes${arrThemes[0]}/$config_file -s ~/.config/waybar/themes${arrThemes[1]}/$style_file > /tmp/waybar.log 2>&1 &
    disown
else
    echo ":: Waybar disabled"
fi

# Explicitly release the lock (optional) -> flock releases on exit
flock -u 200
exec 200>&-