# Applies core system and user configurations.

msg "Copying user configuration files from dotfiles..."
cp -R ~/.local/share/dotfiles/config/* ~/.config/

msg "Linking mini-deps-snap for Neovim..."
if [ -d ~/.local/share/dotfiles/default/nvim/mini-deps-snap ]; then
  ln -sf ~/.local/share/dotfiles/default/nvim/mini-deps-snap ~/.config/nvim/mini-deps-snap
fi

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
