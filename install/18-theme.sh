# Configures system-wide and application-specific themes.

msg "Configuring system themes..."

# Use dark mode for QT apps (like kdenlive) via Kvantum.
install_packages kvantum-qt5

# Set GTK theme to Adwaita-dark.
install_packages gnome-themes-extra
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

msg "Setting up theme symlinks..."
mkdir -p ~/.config/dotfiles/themes
for f in ~/.local/share/dotfiles/themes/*; do
  ln -sfn "$f" ~/.config/dotfiles/themes/
done

# Set initial 'kanagawa' theme.
mkdir -p ~/.config/dotfiles/current
ln -snf ~/.config/dotfiles/themes/kanagawa ~/.config/dotfiles/current/theme
ln -snf ~/.config/dotfiles/current/theme/hyprlock.conf ~/.config/hypr/hyprlock.conf
ln -snf ~/.config/dotfiles/current/theme/wofi.css ~/.config/wofi/style.css

# btop theme
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/dotfiles/current/theme/btop.theme ~/.config/btop/themes/current.theme

# mako theme
mkdir -p ~/.config/mako
ln -snf ~/.config/dotfiles/current/theme/mako.ini ~/.config/mako/config

# Set initial background
source ~/.local/share/dotfiles/themes/kanagawa/backgrounds.sh
ln -snf ~/.config/dotfiles/backgrounds/kanagawa ~/.config/dotfiles/current/backgrounds
ln -snf ~/.config/dotfiles/current/backgrounds/2-kanagawa.jpg ~/.config/dotfiles/current/background

# Set ghostty theme
source ~/.local/share/dotfiles/themes/kanagawa/ghostty.sh
