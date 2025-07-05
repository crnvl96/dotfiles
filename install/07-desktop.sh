# Installs core desktop applications and utilities.

msg "Installing core desktop applications..."

desktop_packages=(
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
  "clipse-bin"          # Clipboard manager
  # "cliphist"        # Manager for xwayland (nvidia)

  # Core GNOME utilities
  "nautilus" "sushi" "gnome-calculator"

  # Essential Apps
  "chromium" "mpv" "evince" "imv" "localsend-bin"
)

install_packages "${desktop_packages[@]}"
