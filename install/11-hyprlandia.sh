# Installs Hyprland and its ecosystem of tools.

msg "Installing Hyprland and related components..."

local -a hyprland_packages=(
  # The Wayland compositor itself
  "hyprland"

  # Hyprland ecosystem tools
  "hyprshot" "hyprpicker" "hyprlock" "hypridle" "hyprpolkitagent" "hyprland-qtutils"

  # Core UI components
  "wofi" "waybar" "mako" "swaybg"

  # XDG portals for application integration (e.g., file pickers)
  "xdg-desktop-portal-hyprland" "xdg-desktop-portal-gtk"
)
install_packages "${hyprland_packages[@]}"

msg "Configuring Hyprland to start automatically on TTY1..."
# This line in .bash_profile executes Hyprland if not already in a graphical session.
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland" >~/.bash_profile
