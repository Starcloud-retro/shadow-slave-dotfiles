# ❖ Shadow Slave — Hyprland Desktop Environment

> *"From the shadows we rise. Lost from light, bound to truth."*

An aesthetic, distraction-free **Arch Linux / EndeavourOS** desktop environment themed after **Shadow Slave** (*The Stormlit Citadel* & *The Storm Sea*), customized specifically for scientific research, mathematics, coding, and AI workflows.

---

## 🚀 Quick Setup & Installation

Clone the repository and run the automated installer:

```bash
git clone git@github.com:Starcloud-retro/shadow-slave-dotfiles.git ~/shadow-slave-dotfiles
cd ~/shadow-slave-dotfiles
chmod +x install.sh
./install.sh
```

### Deployment Modes
* **Default (Symlink Mode)**: Links repo folders into `~/.config/`. Any edits you make in `~/.config/` immediately reflect in the git repo.
  ```bash
  ./install.sh
  ```
* **Copy Mode (`--copy` / `-c`)**: Copies the configuration files directly into `~/.config/` without symlinks.
  ```bash
  ./install.sh --copy
  ```

### Safe Automated Backups
Before linking or copying, `install.sh` automatically detects any pre-existing configuration folders (e.g. `~/.config/hypr`) and creates a timestamped backup (`~/.config/<folder>.bak.YYYY-MM-DD`). Existing files are never clobbered.

---

## 🖥️ Machine-Specific Display & GPU Setup (`monitors.conf`)

Display resolutions, refresh rates, scaling factors, and GPU-specific drivers are completely isolated from the main configuration into a modular file: **`~/.config/hypr/monitors.conf`** (sourced directly by `hyprland.conf`).

### Default Behavior
Out of the box, `monitors.conf` uses auto-detection:
```hyprlang
monitor=,preferred,auto,1
```

### Customizing for Your Hardware
Open `~/.config/hypr/monitors.conf` to tailor your setup:

* **Laptop Internal Display**:
  ```hyprlang
  monitor = eDP-1, 1920x1080@60, 0x0, 1
  ```
* **Dual Monitor Setup (Laptop below external monitor)**:
  ```hyprlang
  monitor = eDP-1, 1920x1080@60, 0x1080, 1
  monitor = HDMI-A-1, 1920x1080@60, 0x0, 1
  ```
* **HiDPI / 2K Display (Fractional Scaling)**:
  ```hyprlang
  monitor = eDP-1, 2560x1440@120, 0x0, 1.25
  ```
* **NVIDIA Proprietary GPU Drivers**:
  Uncomment the hardware acceleration variables in `monitors.conf`:
  ```hyprlang
  env = LIBVA_DRIVER_NAME,nvidia
  env = __GLX_VENDOR_LIBRARY_NAME,nvidia
  env = NVD_BACKEND,direct
  env = ELECTRON_OZONE_PLATFORM_HINT,auto
  ```
* **Virtual Machine / Software Rendering (KVM / QEMU)**:
  ```hyprlang
  env = WLR_RENDERER_ALLOW_SOFTWARE,1
  ```

After editing, apply instantly without logging out:
```bash
hyprctl reload
```

---

## 📦 Required Packages (EndeavourOS / Arch Linux)

`install.sh` automatically audits your system and prints any missing packages. You can install all dependencies via `pacman` and an AUR helper (`yay` / `paru`):

### Official Repositories (`pacman`)
```bash
sudo pacman -S --needed \
  hyprland \
  waybar \
  rofi \
  kitty \
  konsole \
  grim \
  slurp \
  wl-clipboard \
  cliphist \
  swaybg \
  hyprlock \
  hypridle \
  fastfetch \
  brightnessctl \
  playerctl \
  pavucontrol \
  ttf-jetbrains-mono-nerd \
  otf-font-awesome
```

### AUR Packages (`yay`)
```bash
yay -S --needed \
  nwg-dock-hyprland \
  swaync \
  wlogout
```

---

## ⚡ Workstation Spaces (Master Vault Alignment)

The Waybar top panel dynamically reflects personal research domains without distracting icon clutter:

| Workspace | Domain | Intended Workflow |
|---|---|---|
| **1** | **Web** | Documentation, arXiv, literature discovery, browser searches |
| **2** | **Code** | VS Code / Neovim, git staging, development environments |
| **3** | **Research** | Paper reading, PDF annotations, Zotero references |
| **4** | **Math** | Formula derivations, proof notebooks, LaTeX, SymPy |
| **5** | **Astrochem**| Astrochemical reaction simulations, spectroscopy modeling |
| **6** | **Vault** | Master Vault notes, Obsidian knowledge base, personal logs |
| **7** | **Comm** | Discord, communication channels, collaborative tools |
| **8** | **System** | System monitor, hardware metrics, audio mixers, package managers |

---

## 🌌 Key Highlights & Features

- **Shadow Slave Aesthetics**:
  - Dark Void obsidian palette with subtle deep twilight and violet accents (`#9d4edd`, `#7b2cbf`).
  - Native **Grenze Gotisch** calligraphy headers on lockscreen and banners.
  - Wallpapers: *The Stormlit Citadel* and *The Storm Sea Map*.
- **Auto-Hiding Floating Dock**:
  - `nwg-dock-hyprland` configured with auto-hide (`-d`) and zero hover delay (`-hd 0`). Stays hidden until mouse hovers over the bottom screen edge.
- **Persistent AI Continuity**:
  - Smart `agy` wrapper ensures typing `agy` in any terminal across all 8 workspaces immediately continues your active conversation with zero flag micromanagement.
- **Hyprlock Lockscreen**:
  - Dual-layer dramatic screen lock featuring the Stormlit Citadel background and holographic Storm Sea Map badge.
- **Clean Modern Hyprland**:
  - Full compatibility with modern Hyprland v0.56+ syntax (`match:class` / clean rule definitions).

---

## ⌨️ Essential Keybindings

| Keybinding | Action |
|---|---|
| **`Super + Return`** | Open Kitty Terminal |
| **`Super + Space`** | Application Launcher (Rofi) |
| **`Super + A`** / **`Alt + A`** | Open Antigravity CLI (`agy`) directly |
| **`Alt + 1` .. `Alt + 8`** | Fast hybrid access to primary tools |
| **`Super + E`** | Open File Manager (Dolphin) |
| **`Super + D`** / **`Super + H`** | Show Clean Desktop (Empty workspace) |
| **`Super + V`** | Clipboard Manager (Cliphist) |
| **`PrintScreen`** / **`Super + Shift + S`**| Interactive Region Screenshot (Spectacle / Grimblast) |
| **`Super + Shift + Q`** | Force close active window |
| **`Super + Q`** | Close window cleanly |

---

## 👤 Author
- **Shaik Zaheer Abbas** ([@Starcloud-retro](https://github.com/Starcloud-retro))
- Computational Astrochemistry & Research Systems
