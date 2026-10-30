# ❖ Shadow Slave — Hyprland Desktop Environment

> *"From the shadows we rise. Lost from light, bound to truth."*

An aesthetic, distraction-free **Arch Linux / EndeavourOS** desktop environment themed after **Shadow Slave** (The Stormlit Citadel & The Storm Sea), customized specifically for scientific research, mathematics, coding, and AI workflows.

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

## 🚀 One-Line Installation on a New Machine

Clone the repository and run the automated installer:

```bash
git clone git@github.com:Starcloud-retro/shadow-slave-dotfiles.git ~/shadow-slave-dotfiles
cd ~/shadow-slave-dotfiles
chmod +x install.sh
./install.sh
```

---

## 👤 Author
- **Shaik Zaheer Abbas** ([@Starcloud-retro](https://github.com/Starcloud-retro))
- Computational Astrochemistry & Research Systems
