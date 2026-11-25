#!/usr/bin/env bash
# ==============================================================================
#  ❖ S H A D O W   S L A V E   D O T F I L E S   I N S T A L L E R ❖
#  EndeavourOS / Arch Linux · Hyprland Desktop Environment
#  Author: Shaik Zaheer Abbas (Starcloud-retro)
# ==============================================================================

set -eo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SOURCE="$DOTFILES_DIR/.config"
TIMESTAMP="$(date +%Y-%m-%d)"
TIME_FULL="$(date +%Y-%m-%d_%H%M%S)"

MODE="symlink"
if [[ "$1" == "--copy" || "$1" == "-c" ]]; then
    MODE="copy"
fi

CONFIG_DIRS=(
    "hypr"
    "waybar"
    "nwg-dock-hyprland"
    "rofi"
    "kitty"
    "fastfetch"
    "wlogout"
    "swaync"
)

echo "=============================================================================="
echo "  ❖ Setting up Shadow Slave Hyprland Desktop Environment"
echo "  Mode: $MODE | Source: $DOTFILES_DIR"
echo "=============================================================================="

# 1. Ensure essential destination directories exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Pictures"

# 2. Package Dependency Audit (EndeavourOS / Arch Linux)
echo ""
echo ":: [1/5] Checking required packages..."
PACKAGES_CORE=(
    "hyprland:Hyprland Compositor:hyprland"
    "waybar:Status Bar:waybar"
    "rofi:Application Launcher:rofi"
    "kitty:Terminal Emulator:kitty"
    "grim:Screenshot Utility:grim"
    "slurp:Region Selection:slurp"
    "wl-clipboard:Wayland Clipboard Utility:wl-copy"
    "cliphist:Clipboard History Manager:cliphist"
    "swaybg:Wallpaper Daemon:swaybg"
    "hyprlock:Screen Locker:hyprlock"
    "hypridle:Idle Management Daemon:hypridle"
    "nwg-dock-hyprland:Application Dock:nwg-dock-hyprland"
    "swaync:Notification Center:swaync"
    "wlogout:Wayland Logout Menu:wlogout"
    "fastfetch:System Information Fetch:fastfetch"
    "brightnessctl:Backlight Controller:brightnessctl"
    "playerctl:Media Controller:playerctl"
    "ttf-jetbrains-mono-nerd:JetBrains Mono Nerd Font:pacman"
    "otf-font-awesome:Font Awesome Icons:pacman"
)

missing_pkgs=()
for item in "${PACKAGES_CORE[@]}"; do
    IFS=":" read -r pkg desc bin <<< "$item"
    found=false
    if [ "$bin" != "pacman" ] && command -v "$bin" >/dev/null 2>&1; then
        found=true
    elif pacman -Qi "$pkg" >/dev/null 2>&1 || pacman -Q "$pkg" >/dev/null 2>&1; then
        found=true
    fi
    if [ "$found" = false ]; then
        missing_pkgs+=("$pkg")
    fi
done

if [ ${#missing_pkgs[@]} -eq 0 ]; then
    echo "   ✓ All core packages are installed."
else
    echo "   ! The following packages were not found on this system:"
    for mp in "${missing_pkgs[@]}"; do
        echo "     - $mp"
    done
    echo ""
    echo "   Install them using pacman / yay:"
    echo "     sudo pacman -S --needed ${missing_pkgs[*]}"
    echo "     (or: yay -S --needed ${missing_pkgs[*]})"
fi

# 3. Deploy .config Folders (with automated backup)
echo ""
echo ":: [2/5] Deploying configuration folders to ~/.config/ ($MODE)..."
for dir in "${CONFIG_DIRS[@]}"; do
    src="$CONFIG_SOURCE/$dir"
    dest="$HOME/.config/$dir"

    if [ ! -d "$src" ]; then
        continue
    fi

    # Handle existing target
    if [ -L "$dest" ]; then
        current_target="$(readlink -f "$dest")"
        if [ "$current_target" == "$src" ] && [ "$MODE" == "symlink" ]; then
            echo "   → ~/.config/$dir is already linked to repo."
            continue
        fi
        rm -f "$dest"
    elif [ -e "$dest" ]; then
        backup_path="$HOME/.config/${dir}.bak.${TIMESTAMP}"
        if [ -e "$backup_path" ]; then
            backup_path="$HOME/.config/${dir}.bak.${TIME_FULL}"
        fi
        echo "   → Backing up ~/.config/$dir to $backup_path"
        mv "$dest" "$backup_path"
    fi

    if [ "$MODE" == "symlink" ]; then
        echo "   ✓ Linking $src -> ~/.config/$dir"
        ln -sfn "$src" "$dest"
    else
        echo "   ✓ Copying $src -> ~/.config/$dir"
        cp -r "$src" "$dest"
    fi
done

# Ensure script permissions
find "$HOME/.config/hypr/scripts" -type f -exec chmod +x {} + 2>/dev/null || true
[ -f "$HOME/.config/waybar/launch.sh" ] && chmod +x "$HOME/.config/waybar/launch.sh" || true
[ -f "$HOME/.config/nwg-dock-hyprland/launch.sh" ] && chmod +x "$HOME/.config/nwg-dock-hyprland/launch.sh" || true

# 4. Deploy Wallpapers
echo ""
echo ":: [3/5] Deploying Shadow Slave wallpapers to ~/Pictures..."
if [ -d "$DOTFILES_DIR/wallpapers" ]; then
    cp -u "$DOTFILES_DIR/wallpapers/"* "$HOME/Pictures/" 2>/dev/null || cp "$DOTFILES_DIR/wallpapers/"* "$HOME/Pictures/" 2>/dev/null || true
    echo "   ✓ Wallpapers placed in ~/Pictures/"
fi

# 5. Modular Monitors Check
echo ""
echo ":: [4/5] Checking machine-specific monitor configuration..."
if [ ! -f "$HOME/.config/hypr/monitors.conf" ]; then
    echo "   → Initializing ~/.config/hypr/monitors.conf from template..."
    cp "$DOTFILES_DIR/.config/hypr/monitors.conf" "$HOME/.config/hypr/monitors.conf"
else
    echo "   ✓ Active ~/.config/hypr/monitors.conf found."
fi

# 6. Persistent AI Continuity Wrapper (agy)
echo ""
echo ":: [5/5] Deploying Antigravity continuity CLI wrapper..."
if [ -f "$HOME/.local/bin/agy" ] && [ ! -f "$HOME/.local/bin/agy.bin" ]; then
    if file "$HOME/.local/bin/agy" 2>/dev/null | grep -q "ELF"; then
        mv "$HOME/.local/bin/agy" "$HOME/.local/bin/agy.bin"
    fi
fi

cat << 'AGY_EOF' > "$HOME/.local/bin/agy"
#!/usr/bin/env bash
# Antigravity Persistent Continuity Wrapper
BINARY="$HOME/.local/bin/agy.bin"

if [ ! -f "$BINARY" ]; then
    if command -v agy.bin >/dev/null 2>&1; then
        BINARY="$(command -v agy.bin)"
    elif [ -f "/usr/local/bin/agy.bin" ]; then
        BINARY="/usr/local/bin/agy.bin"
    fi
fi

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
AGY_EOF
chmod +x "$HOME/.local/bin/agy"
echo "   ✓ agy wrapper ready at ~/.local/bin/agy"

echo ""
echo "=============================================================================="
echo "  ✓ Installation complete!"
echo "  Display & Hardware: Edit ~/.config/hypr/monitors.conf for monitor/GPU setups."
echo "  Reload session: Run 'hyprctl reload' or press Super+M."
echo "=============================================================================="
