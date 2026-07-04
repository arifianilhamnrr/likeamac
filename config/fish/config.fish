source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end


# Added by Antigravity CLI installer
set -gx PATH "/home/ar/.local/bin" $PATH

# >>> grok installer >>>
fish_add_path $HOME/.grok/bin
# <<< grok installer <<<

# Desktop session switcher
abbr -a sn 'switch-niri'

# Qt theme — match GTK/MacTahoe on Niri
set -gx QT_QPA_PLATFORMTHEME gtk3

# Client-side window decorations enabled (macOS-style buttons via gtk-decoration-layout)
set -e QT_WAYLAND_DISABLE_WINDOWDECORATION
set -gx GTK_CSD 1
set -gx ELECTRON_OZONE_PLATFORM_HINT wayland

# Default terminal
set -gx TERMINAL kgx

# Qt apps (Telegram, etc.) — macOS-style traffic lights on Wayland
set -gx QT_WAYLAND_DECORATION whitesur-gtk
