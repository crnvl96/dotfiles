# Installs extra applications and integrates their assets.

msg "Installing extra applications..."
extra_packages=(
  "spotify" "zoom"
  "libreoffice" "obs-studio" "kdenlive"
  "xournalpp" "steam" "typora" "bitwarden" "discord"
)
install_packages "${extra_packages[@]}"

msg "Installing custom application icons..."

# Copy over applications
source ~/.local/share/dotfiles/bin/sync-applications || true
