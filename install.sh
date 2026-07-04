#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mv "$dest" "${dest}.bak.$(date +%s)"
        echo "  backed up existing $dest"
    fi
    ln -sfn "$src" "$dest"
    echo "  linked $dest"
}

echo "==> Linking configs from $DOTFILES"

# Niri
link "$DOTFILES/config/niri" "$HOME/.config/niri"

# Noctalia
for f in settings.json colors.json plugins.json; do
    link "$DOTFILES/config/noctalia/$f" "$HOME/.config/noctalia/$f"
done
mkdir -p "$HOME/.config/noctalia/patches" "$HOME/.config/noctalia/icons"
for f in "$DOTFILES/config/noctalia/patches"/*.qml; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f")"
    [[ "$base" == Battery-quickshell.qml ]] && continue
    link "$f" "$HOME/.config/noctalia/patches/$base"
done
for f in "$DOTFILES/config/noctalia/icons"/*; do
    [[ -f "$f" ]] && link "$f" "$HOME/.config/noctalia/icons/$(basename "$f")"
done

# Shell & GTK
link "$DOTFILES/config/fish/config.fish" "$HOME/.config/fish/config.fish"
link "$DOTFILES/config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
link "$DOTFILES/config/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
link "$DOTFILES/config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
link "$DOTFILES/gtk/.gtkrc-2.0" "$HOME/.gtkrc-2.0"

# Environment
mkdir -p "$HOME/.config/environment.d"
for f in "$DOTFILES/config/environment.d"/*; do
    [[ -f "$f" ]] && link "$f" "$HOME/.config/environment.d/$(basename "$f")"
done

# Kvantum & xsettingsd
link "$DOTFILES/config/Kvantum" "$HOME/.config/Kvantum"
mkdir -p "$HOME/.config/xsettingsd"
link "$DOTFILES/config/xsettingsd/xsettingsd.conf" "$HOME/.config/xsettingsd/xsettingsd.conf"

# Browser / Electron flags
for f in brave-flags.conf code-flags.conf electron42-flags.conf; do
    link "$DOTFILES/config/$f" "$HOME/.config/$f"
done

# Plasma (optional — only if you use KDE session)
for f in kwinrc kdeglobals plasmarc plasma-org.kde.plasma.desktop-appletsrc; do
    link "$DOTFILES/config/plasma/$f" "$HOME/.config/$f"
done
mkdir -p "$HOME/.local/share/icons"
link "$DOTFILES/config/plasma/apple-logo.svg" "$HOME/.local/share/icons/apple-logo.svg"

# Scripts
mkdir -p "$HOME/.local/bin"
for f in setup-plasma-macos plasma-macos-panel.js; do
    cp "$DOTFILES/bin/$f" "$HOME/.local/bin/$f"
    chmod +x "$HOME/.local/bin/$f"
    echo "  installed $HOME/.local/bin/$f"
done

# System-wide session switcher (needs sudo)
if [[ "${INSTALL_SWITCH_DESKTOP:-}" == "1" ]]; then
    sudo cp "$DOTFILES/bin/switch-desktop" /usr/local/bin/switch-desktop
    sudo cp "$DOTFILES/bin/switch-niri" /usr/local/bin/switch-niri
    sudo cp "$DOTFILES/bin/switch-plasma" /usr/local/bin/switch-plasma
    sudo chmod +x /usr/local/bin/switch-desktop /usr/local/bin/switch-niri /usr/local/bin/switch-plasma
    echo "  installed session switchers to /usr/local/bin/"
fi

echo ""
echo "Done. Install themes separately — see README.md"
echo "Run: INSTALL_SWITCH_DESKTOP=1 ./install.sh  (to install switch-niri/switch-plasma)"