# likeamac — macOS-style Niri desktop

Konfigurasi desktop **Niri + Noctalia** dengan tema macOS (MacTahoe).

## Ringkasan setup

| Komponen | Detail |
|---|---|
| **Distro** | CachyOS |
| **Compositor** | Niri (Wayland) |
| **Shell UI** | [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell) via QuickShell |
| **Shell** | Fish (dengan `cachyos-fish-config`) |
| **Terminal** | GNOME Console (`kgx`) |
| **GTK theme** | [MacTahoe-Dark](https://github.com/vinceliuice/MacTahoe-gtk-theme) |
| **Icon theme** | [MacTahoe-dark](https://github.com/vinceliuice/MacTahoe-icon-theme) |
| **Cursor** | WhiteSur-cursors (GTK) / capitaine-cursors (Niri) |
| **Font UI** | SF Pro Text (apple-fonts) |
| **Font monospace** | SF Mono, JetBrains Mono, Meslo Nerd Font |

## Aplikasi

| Aplikasi | Peran |
|---|---|
| **firefox** / **brave-browser** | Browser |
| **nautilus** | File manager |
| **kgx** (GNOME Console) | Terminal default |
| **code-oss** | Editor |
| **gpu-screen-recorder** (`gsr-ui`) | Screen recorder |
| **wl-clipboard** + **cliphist** | Clipboard history |
| **easyeffects** | Audio effects |

### Plugin Noctalia

- `keybind-cheatsheet`
- `linux-wallpaperengine-controller`
- `polkit-agent`
- `mpris-lyrics`

## Shortcut

| Shortcut | Aksi |
|---|---|
| `Mod+Space` | Noctalia launcher (Spotlight) |
| `Mod+Return` | Terminal (kgx) |
| `Mod+E` | Nautilus |
| `Mod+B` | Firefox |
| `Mod+L` | Session menu |
| `Mod+Alt+L` | Lock screen |
| `Mod+Q` | Tutup window |
| `Mod+O` | Overview |
| `Mod+F12` | Screenshot region |
| `Mod+Shift+F12` | Screenshot fullscreen |
| `Mod+Shift+R` | Toggle screen recording |
| `XF86Audio*` | Volume & media (via Noctalia) |
| `XF86MonBrightness*` | Brightness (via Noctalia) |

Fish abbreviation: `sn` → `switch-niri`

## Instalasi

### 1. Paket sistem

```bash
sudo pacman -S niri noctalia-shell cachyos-niri-noctalia \
  gnome-console nautilus inter-font apple-fonts \
  capitaine-cursors wl-clipboard gpu-screen-recorder \
  gpu-screen-recorder-ui easyeffects sassc git

# Lihat packages.txt untuk daftar lengkap
```

### 2. Install dotfiles

```bash
git clone https://github.com/arifianilhamnrr/likeamac.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

`install.sh` otomatis mengunduh dan memasang **MacTahoe GTK/icons** + **WhiteSur cursors** dari GitHub vinceliuice. Cache clone ada di `~/.cache/likeamac-themes`.

```bash
INSTALL_THEMES=0 ./install.sh                    # skip unduhan tema
INSTALL_SWITCH_DESKTOP=1 ./install.sh            # install switch-niri ke /usr/local/bin
```

### 3. Set sesi default

```bash
switch-niri          # set Niri sebagai default (login berikutnya)
switch-niri now      # logout & apply sekarang
```

## Struktur repo

```
dotfiles/
├── bin/                  # switch-desktop, switch-niri
├── config/
│   ├── niri/             # Niri compositor + keybinds
│   ├── noctalia/         # Noctalia shell settings, patches, icons
│   ├── fish/             # Fish shell
│   ├── gtk-3.0/          # GTK3 theme + custom CSS
│   ├── gtk-4.0/          # GTK4 theme
│   ├── environment.d/    # Wayland/GTK env vars
│   └── xsettingsd/       # X11 GTK settings fallback
├── gtk/.gtkrc-2.0
├── packages.txt
└── install.sh
```

## Kustomisasi

- **Noctalia bar**: macOS-style icons (battery, wifi, control center, search)
- **Noctalia patches**: `Battery.qml`, `MediaMini.qml`
- **GTK CSS**: titlebar rounded top (macOS traffic lights style)
- **Niri rules**: window corner radius 12px, natural scroll, focus-follows-mouse
- **Color scheme**: wallpaper-based vibrant colors (Jakarta timezone)

## Wallpaper

Disimpan di `~/Pictures/Wallpapers/` (tidak di-repo).

## Environment variables

| Variable | Default | Fungsi |
|---|---|---|
| `INSTALL_THEMES` | `1` | Unduh & install MacTahoe + WhiteSur cursors |
| `INSTALL_SWITCH_DESKTOP` | `0` | Install `switch-niri` ke `/usr/local/bin` |
| `THEMES_CACHE` | `~/.cache/likeamac-themes` | Lokasi cache git clone tema |