# Installs extra applications and integrates their assets.

msg "Installing extra applications..."
extra_packages=(
  "spotify" "zoom"
  "typora" "libreoffice" "obs-studio" "kdenlive"
  "pinta" "xournalpp" "steam"
)
install_packages "${extra_packages[@]}"

msg "Installing custom application icons..."
mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
cp ~/.local/share/dotfiles/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/
gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null

msg "Installing custom .desktop files..."
mkdir -p ~/.local/share/applications
cp ~/.local/share/dotfiles/applications/*.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications

msg "Done!"
