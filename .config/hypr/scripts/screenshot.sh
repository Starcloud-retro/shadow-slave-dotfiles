#!/usr/bin/env bash
# High-speed native Wayland screenshot helper for Hyprland using grimblast

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
FILENAME="screenshot_$(date +'%Y%m%d_%H%M%S').png"

case "$1" in
    --instant|--full)
        grimblast --notify copysave screen "$SAVE_DIR/$FILENAME"
        ;;
    --instant-area|--area|*)
        grimblast --notify copysave area "$SAVE_DIR/$FILENAME"
        ;;
esac
