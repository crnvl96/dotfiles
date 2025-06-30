# Use dark mode for QT apps too (like VLC and kdenlive)
sudo pacman -S --noconfirm kvantum-qt5

# Prefer dark mode everything
sudo pacman -S --noconfirm gnome-themes-extra # Adds Adwaita-dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Setup theme links
mkdir -p ~/.config/dotfiles/themes
for f in ~/.local/share/dotfiles/themes/*; do ln -s "$f" ~/.config/dotfiles/themes/; done

# Set initial theme
mkdir -p ~/.config/dotfiles/current
ln -snf ~/.config/dotfiles/themes/kanagawa ~/.config/dotfiles/current/theme
source ~/.local/share/dotfiles/themes/kanagawa/backgrounds.sh
ln -snf ~/.config/dotfiles/backgrounds/kanagawa ~/.config/dotfiles/current/backgrounds
ln -snf ~/.config/dotfiles/current/backgrounds/1-kanagawa.jpg ~/.config/dotfiles/current/background

# Set specific app links for current theme
ln -snf ~/.config/dotfiles/current/theme/hyprlock.conf ~/.config/hypr/hyprlock.conf
ln -snf ~/.config/dotfiles/current/theme/wofi.css ~/.config/wofi/style.css
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/dotfiles/current/theme/btop.theme ~/.config/btop/themes/current.theme
mkdir -p ~/.config/mako
ln -snf ~/.config/dotfiles/current/theme/mako.ini ~/.config/mako/config
