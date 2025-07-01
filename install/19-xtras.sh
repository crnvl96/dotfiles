yay -S --noconfirm --needed \
  spotify zoom \
  typora libreoffice obs-studio kdenlive \
  pinta xournalpp steam

# Copy and sync icon files
mkdir -p ~/.local/share/icons/hicolor/48x48/apps/
cp ~/.local/share/dotfiles/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/
gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null

# Copy .desktop declarations
mkdir -p ~/.local/share/applications
cp ~/.local/share/dotfiles/applications/*.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications
