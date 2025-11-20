# gnome-keyring
# 1. Start Gnome Keyring and export its variables
eval $(gnome-keyring-daemon --start --components=secrets,ssh)
export SSH_AUTH_SOCK
# 2. (Optional) Apply environment variables to systemd user session 
# This helps other apps find the keyring
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP SSH_AUTH_SOCK

# top bar
waybar -c ~/.config/mango/waybar/config.jsonc -s ~/.config/mango/waybar/style.css >/dev/null 2>&1 &

# Tell dbus about the Wayland session so it can launch portals
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots &

# --- Add these lines for Dark Theme ---
# Tells modern apps (GTK4, Flatpak) to prefer dark mode
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Tells older GTK3 apps to use a specific dark theme (e.g., Adwaita-dark)
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'

keyd-application-mapper -d

# notification
mako &

# background
awww-daemon --format xrgb &
sleep 0.2
awww img ~/pictures/rust.png

# IME
fcitx5 -d --replace

# kanshi
kanshi &
