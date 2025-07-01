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
for icon in ~/.local/share/dotfiles/applications/icons/*.png; do
  [ -f "$icon" ] && cp "$icon" ~/.local/share/icons/hicolor/48x48/apps/
done
gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null

msg "Installing custom .desktop files..."
mkdir -p ~/.local/share/applications
for desktop_file in ~/.local/share/dotfiles/applications/*.desktop; do
  [ -f "$desktop_file" ] && cp "$desktop_file" ~/.local/share/applications/
done
update-desktop-database ~/.local/share/applications
