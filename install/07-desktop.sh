# Installs core desktop applications and utilities.

msg "Installing core desktop applications..."

local -a desktop_packages=(
  # System tray and session utilities
  "brightnessctl"  # Control screen brightness
  "playerctl"      # Control media players
  "pamixer"        # Pulseaudio mixer
  "pavucontrol"    # Pulseaudio volume control
  "wireplumber"    # Session manager for PipeWire

  # Input method
  "fcitx5" "fcitx5-gtk" "fcitx5-qt" "fcitx5-configtool"

  # Clipboard management
  "wl-clip-persist" # Persist clipboard content after closing apps
  "clipse"          # Clipboard manager

  # Core GNOME utilities
  "nautilus" "sushi" "gnome-calculator"

  # Essential Apps
  "bitwarden" "chromium" "vlc" "evince" "imv"
)

install_packages "${desktop_packages[@]}"
