# dotfiles — macOS-style CachyOS setup

Konfigurasi desktop **Niri + Noctalia** (sesi utama) dan **KDE Plasma** (sesi alternatif) dengan tema macOS.

## Ringkasan setup

| Komponen | Detail |
|---|---|
| **Distro** | CachyOS |
| **Sesi utama** | Niri (Wayland compositor) |
| **Shell UI** | [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell) via QuickShell |
| **Sesi alternatif** | KDE Plasma 6 (WhiteSur + Kvantum) |
| **Shell** | Fish (dengan `cachyos-fish-config`) |
| **Terminal** | GNOME Console (`kgx`) |
| **Tema GTK (Niri)** | [MacTahoe-Dark](https://github.com/vinceliuice/MacTahoe-gtk-theme) |
| **Ikon (Niri)** | [MacTahoe-dark](https://github.com/vinceliuice/MacTahoe-icon-theme) |
| **Tema GTK (Plasma)** | [WhiteSur-dark](https://github.com/vinceliuice/WhiteSur-gtk-theme) via Kvantum |
| **Ikon (Plasma)** | WhiteSur-dark |
| **Cursor** | WhiteSur-cursors (GTK) / capitaine-cursors (Niri) |
| **Font UI** | SF Pro Text (apple-fonts), Inter |
| **Font monospace** | SF Mono, JetBrains Mono, Meslo Nerd Font |

## Aplikasi yang dipakai di tema

| Aplikasi | Peran |
|---|---|
| **firefox** / **brave-browser** | Browser |
| **nautilus** | File manager (Niri) |
| **org.gnome.Nautilus** | File manager (dock) |
| **kgx** (GNOME Console) | Terminal default |
| **code-oss** | Editor |
| **spotify-launcher** | Musik |
| **gpu-screen-recorder** (`gsr-ui`) | Screen recorder |
| **wl-clipboard** + **cliphist** | Clipboard history |
| **easyeffects** | Audio effects |

### Plugin Noctalia

- `keybind-cheatsheet`
- `linux-wallpaperengine-controller`
- `polkit-agent`
- `mpris-lyrics`

### Widget Plasma (sesi KDE)

- **AppGrid** (`dev.xarbit.appgrid.panel`) — launcher ala Spotlight, shortcut `Meta+Space`
- **WaveTask** (`org.vicko.wavetask`) — dock macOS dengan skin "Tahoe Dark"

## Shortcut penting (Niri)

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

## Shortcut Plasma

| Shortcut | Aksi |
|---|---|
| `Meta+Space` | AppGrid launcher |
| `Meta+L` | Lock session |

## Instalasi

### 1. Paket sistem

```bash
# Dari CachyOS repo
sudo pacman -S niri noctalia-shell cachyos-niri-noctalia \
  gnome-console nautilus kvantum inter-font apple-fonts \
  capitaine-cursors wl-clipboard gpu-screen-recorder \
  gpu-screen-recorder-ui easyeffects orchis-theme

# Lihat packages.txt untuk daftar lengkap yang pernah di-install
```

### 2. Tema (otomatis via `install.sh`)

`install.sh` mengunduh dan memasang tema dari GitHub vinceliuice:

| Tema | Repo | Untuk |
|---|---|---|
| MacTahoe GTK | MacTahoe-gtk-theme | Sesi Niri |
| MacTahoe icons | MacTahoe-icon-theme | Sesi Niri |
| WhiteSur GTK | WhiteSur-gtk-theme | Sesi Plasma |
| WhiteSur icons | WhiteSur-icon-theme | Sesi Plasma |
| WhiteSur cursors | WhiteSur-cursor-theme | Semua sesi |
| WhiteSur KDE | WhiteSur-kde | Aurorae, Kvantum, Plasma |

Butuh `git` dan `sassc`. Cache clone ada di `~/.cache/likeamac-themes`.

```bash
# Lewati unduhan tema (kalau sudah terpasang):
INSTALL_THEMES=0 ./install.sh
```

### 3. Plasma widgets (opsional)

Install **AppGrid** dan **WaveTask** dari KDE Store / AUR jika pakai sesi Plasma.

### 4. Install dotfiles

```bash
git clone https://github.com/arifianilhamnrr/likeamac.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh

# Tanpa unduh tema + dengan session switcher:
INSTALL_THEMES=0 INSTALL_SWITCH_DESKTOP=1 ./install.sh
```

### 5. Ganti sesi desktop

```bash
switch-niri          # set Niri sebagai default (login berikutnya)
switch-niri now      # logout & switch sekarang
switch-plasma        # set Plasma sebagai default
switch-plasma now
```

Untuk Plasma macOS layout:

```bash
setup-plasma-macos
```

## Struktur repo

```
dotfiles/
├── bin/                  # Scripts (switch-desktop, setup-plasma-macos, ...)
├── config/
│   ├── niri/             # Niri compositor + keybinds
│   ├── noctalia/         # Noctalia shell settings, patches, icons
│   ├── fish/             # Fish shell
│   ├── gtk-3.0/          # GTK3 theme + custom CSS
│   ├── gtk-4.0/          # GTK4 theme
│   ├── environment.d/    # Wayland/GTK env vars
│   ├── Kvantum/          # Kvantum theme (Plasma)
│   ├── plasma/           # KDE Plasma layout & theme
│   └── xsettingsd/       # X11 GTK settings fallback
├── gtk/.gtkrc-2.0
├── packages.txt          # Daftar paket pacman
└── install.sh
```

## Kustomisasi khusus

- **Noctalia bar**: macOS-style icons (battery, wifi, control center, search)
- **Noctalia patches**: `Battery.qml`, `MediaMini.qml` — widget bar custom
- **GTK CSS**: titlebar rounded top (macOS traffic lights style)
- **Niri rules**: window corner radius 12px, natural scroll, focus-follows-mouse
- **Color scheme**: wallpaper-based vibrant colors (Jakarta timezone)

## Wallpaper

Disimpan di `~/Pictures/Wallpapers/` (tidak di-repo).

## Environment variables

| Variable | Default | Fungsi |
|---|---|---|
| `INSTALL_THEMES` | `1` | Unduh & install MacTahoe + WhiteSur themes |
| `INSTALL_SWITCH_DESKTOP` | `0` | Install `switch-niri` / `switch-plasma` ke `/usr/local/bin` |
| `THEMES_CACHE` | `~/.cache/likeamac-themes` | Lokasi cache git clone tema |