#!/usr/bin/env bash
# ==============================================================================
#  ❖ S H A D O W   S L A V E   D O T F I L E S   I N S T A L L E R ❖
#  EndeavourOS / Arch Linux · Hyprland Desktop Environment
#  Author: Shaik Zaheer Abbas (Starcloud-retro)
# ==============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "--------------------------------------------------------"
echo "  ❖ Setting up Shadow Slave Hyprland Desktop Environment"
echo "--------------------------------------------------------"

# 1. Ensure required directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Pictures"

# 2. Backup existing configs
echo ":: Creating backup in $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
for dir in hypr waybar nwg-dock-hyprland rofi kitty fastfetch wlogout swaync; do
    if [ -d "$HOME/.config/$dir" ]; then
        cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
done

# 3. Deploy .config folders
echo ":: Deploying configuration files..."
cp -r "$DOTFILES_DIR/.config/"* "$HOME/.config/"

# Ensure all scripts have execute permissions
find "$HOME/.config/hypr/scripts" -type f -exec chmod +x {} + 2>/dev/null || true
chmod +x "$HOME/.config/waybar/launch.sh" 2>/dev/null || true
chmod +x "$HOME/.config/nwg-dock-hyprland/launch.sh" 2>/dev/null || true

# 4. Deploy Wallpapers
echo ":: Deploying Shadow Slave wallpapers to ~/Pictures..."
cp "$DOTFILES_DIR/wallpapers/"* "$HOME/Pictures/" 2>/dev/null || true

# 5. Deploy Antigravity Continuity CLI wrapper
if [ -f "$HOME/.local/bin/agy" ] && [ ! -f "$HOME/.local/bin/agy.bin" ]; then
    if file "$HOME/.local/bin/agy" | grep -q "ELF"; then
        mv "$HOME/.local/bin/agy" "$HOME/.local/bin/agy.bin"
    fi
fi

cat << 'EOF' > "$HOME/.local/bin/agy"
#!/usr/bin/env bash
# Antigravity Persistent Continuity Wrapper
BINARY="$HOME/.local/bin/agy.bin"

if [ "$1" = "new" ]; then
    shift
    exec "$BINARY" "$@"
fi

has_override=false
for arg in "$@"; do
    case "$arg" in
        -c|--continue|--conversation|--new-project|mcp|plugin|plugins|update|agent|agents|help|--help|-h|version|--version)
            has_override=true
            break
            ;;
    esac
done

if [ "$has_override" = true ]; then
    exec "$BINARY" "$@"
else
    exec "$BINARY" --continue "$@"
fi
EOF
chmod +x "$HOME/.local/bin/agy"

echo "--------------------------------------------------------"
echo "✓ Installation complete!"
echo "  Run 'hyprctl reload' or restart your Hyprland session."
echo "--------------------------------------------------------"
