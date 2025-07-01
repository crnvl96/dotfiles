# Copy over Dotfiles configs
cp -R ~/.local/share/dotfiles/config/* ~/.config/

# Use default bashrc from Dotfiles
echo "source ~/.local/share/dotfiles/default/bash/bashrc" >~/.bashrc

# Login directly as user, rely on disk encryption + hyprlock for security
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF
