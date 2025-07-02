# Applies core system and user configurations.

msg "Symlinking user configuration files from dotfiles..."

for item in ~/.local/share/dotfiles/config/*; do
    target=~/.config/$(basename "$item")
    if [ -e "$target" ]; then
        msg "Overwriting existing $target with symlink"
    fi
    ln -sf "$item" "$target"
    msg "Created/Updated symlink for $(basename "$item")"
done

msg "Setting default .bashrc to source from dotfiles..."
echo "source ~/.local/share/dotfiles/default/bash/bashrc" >~/.bashrc

msg "Configuring auto-login for TTY1..."
# This avoids the need to enter a password on boot for the console user.
# Security is handled by disk encryption and the Hyprland lock screen.
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF
