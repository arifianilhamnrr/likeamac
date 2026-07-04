#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_CACHE="${THEMES_CACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/likeamac-themes}"
INSTALL_THEMES="${INSTALL_THEMES:-1}"

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

require_cmd() {
    local cmd="$1" pkg="${2:-$1}"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Missing dependency: $cmd (install with: sudo pacman -S $pkg)"
        exit 1
    fi
}

clone_or_pull() {
    local url="$1" dir="$2"
    if [[ -d "$THEMES_CACHE/$dir/.git" ]]; then
        echo "  updating $dir..."
        git -C "$THEMES_CACHE/$dir" pull --ff-only
    else
        echo "  cloning $dir..."
        git clone --depth 1 "$url" "$THEMES_CACHE/$dir"
    fi
}

run_theme_installer() {
    local dir="$1"
    shift
    (cd "$THEMES_CACHE/$dir" && ./install.sh "$@")
}

install_themes() {
    echo "==> Installing themes (cache: $THEMES_CACHE)"
    require_cmd git
    require_cmd sassc
    mkdir -p "$THEMES_CACHE"

    echo "-> MacTahoe GTK"
    clone_or_pull https://github.com/vinceliuice/MacTahoe-gtk-theme.git MacTahoe-gtk-theme
    run_theme_installer MacTahoe-gtk-theme --silent-mode -c dark -l

    echo "-> MacTahoe icons"
    clone_or_pull https://github.com/vinceliuice/MacTahoe-icon-theme.git MacTahoe-icon-theme
    run_theme_installer MacTahoe-icon-theme

    echo "-> WhiteSur cursors"
    clone_or_pull https://github.com/vinceliuice/WhiteSur-cursor-theme.git WhiteSur-cursor-theme
    run_theme_installer WhiteSur-cursor-theme

    echo "  themes installed"
}

install_termius() {
    if ! command -v flatpak >/dev/null 2>&1; then
        echo "  skipping Termius setup (flatpak not installed)"
        return 0
    fi
    if ! flatpak info com.termius.Termius >/dev/null 2>&1; then
        echo "  skipping Termius setup (com.termius.Termius not installed)"
        return 0
    fi

    echo "==> Configuring Termius (traffic-light decorations)"

    local termius_config="$HOME/.var/app/com.termius.Termius/config"

    mkdir -p "$HOME/.local/share/flatpak/overrides"
    cp "$DOTFILES/config/flatpak/overrides/com.termius.Termius" \
        "$HOME/.local/share/flatpak/overrides/com.termius.Termius"
    flatpak override --user com.termius.Termius \
        --unset-env=QT_WAYLAND_DISABLE_WINDOWDECORATION
    echo "  applied flatpak overrides"

    mkdir -p "$HOME/.local/share/applications"
    cp "$DOTFILES/config/applications/com.termius.Termius.desktop" \
        "$HOME/.local/share/applications/com.termius.Termius.desktop"
    echo "  installed desktop entry"

    mkdir -p "$termius_config/gtk-3.0" "$termius_config/gtk-4.0"
    rm -f "$termius_config/gtk-3.0/settings.ini" "$termius_config/gtk-4.0/settings.ini"
    cp "$DOTFILES/config/gtk-3.0/settings.ini" "$termius_config/gtk-3.0/settings.ini"
    cp "$DOTFILES/config/gtk-4.0/settings.ini" "$termius_config/gtk-4.0/settings.ini"
    cp "$DOTFILES/config/termius-flags.conf" "$termius_config/termius-flags.conf"

    local asar_path patch_stamp patch_tmp
    asar_path="$(find /var/lib/flatpak/app/com.termius.Termius -path '*/files/extra/termius/resources/app.asar' 2>/dev/null | head -1)"
    if [[ -z "$asar_path" ]]; then
        echo "  warning: could not find Termius app.asar to patch"
        return 0
    fi

    patch_stamp="${termius_config}/.asar-patch-stamp"
    if python3 "$DOTFILES/scripts/patch-termius-asar.py" --check "$asar_path"; then
        echo "  Termius app.asar already patched"
    else
        patch_tmp="$(mktemp)"
        cp "$asar_path" "$patch_tmp"
        python3 "$DOTFILES/scripts/patch-termius-asar.py" "$patch_tmp"
        if ! sudo install -m 644 -o root -g root "$patch_tmp" "$asar_path"; then
            echo "  warning: sudo required to patch Termius app.asar (run install.sh again)"
            rm -f "$patch_tmp"
            return 0
        fi
        rm -f "$patch_tmp"
        echo "  installed patched Termius app.asar"
    fi
    printf '%s\n' "$asar_path" > "$patch_stamp"

    rm -rf "$termius_config/termius-runtime"
    echo "  cleaned old Termius runtime copy"
}

link_configs() {
    echo "==> Linking configs from $DOTFILES"

    link "$DOTFILES/config/niri" "$HOME/.config/niri"

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

    link "$DOTFILES/config/fish/config.fish" "$HOME/.config/fish/config.fish"
    link "$DOTFILES/config/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
    link "$DOTFILES/config/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"
    link "$DOTFILES/config/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
    link "$DOTFILES/gtk/.gtkrc-2.0" "$HOME/.gtkrc-2.0"

    mkdir -p "$HOME/.config/environment.d"
    for f in "$DOTFILES/config/environment.d"/*; do
        [[ -f "$f" ]] && link "$f" "$HOME/.config/environment.d/$(basename "$f")"
    done

    mkdir -p "$HOME/.config/xsettingsd"
    link "$DOTFILES/config/xsettingsd/xsettingsd.conf" "$HOME/.config/xsettingsd/xsettingsd.conf"

    for f in brave-flags.conf code-flags.conf electron42-flags.conf; do
        link "$DOTFILES/config/$f" "$HOME/.config/$f"
    done

    mkdir -p "$HOME/.config/niriswitcher"
    if [[ -f "$DOTFILES/config/niriswitcher/config.toml" ]]; then
        cp "$DOTFILES/config/niriswitcher/config.toml" "$HOME/.config/niriswitcher/config.toml"
        echo "  installed $HOME/.config/niriswitcher/config.toml"
    fi

    if [[ "${INSTALL_SWITCH_DESKTOP:-}" == "1" ]]; then
        sudo cp "$DOTFILES/bin/switch-desktop" /usr/local/bin/switch-desktop
        sudo cp "$DOTFILES/bin/switch-niri" /usr/local/bin/switch-niri
        sudo chmod +x /usr/local/bin/switch-desktop /usr/local/bin/switch-niri
        echo "  installed session switchers to /usr/local/bin/"
    fi
}

if [[ "$INSTALL_THEMES" == "1" ]]; then
    install_themes
else
    echo "==> Skipping themes (INSTALL_THEMES=0)"
fi

link_configs
install_termius

echo ""
echo "Done!"
echo "  INSTALL_THEMES=0 ./install.sh          — skip theme download"
echo "  INSTALL_SWITCH_DESKTOP=1 ./install.sh  — install switch-niri"