# Installs and configures NVIDIA drivers for Hyprland.

msg "Checking for NVIDIA GPU..."

gpu_info=$(lspci | grep -i 'nvidia')
if [ -z "$gpu_info" ]; then
    msg "No NVIDIA GPU found. Skipping."
    return
fi

msg "NVIDIA GPU detected. Installing drivers and configuring system..."

# --- Driver Selection ---
# Select open-source or proprietary driver based on GPU architecture.
if echo "$gpu_info" | grep -q -E "RTX [2-9][0-9]|GTX 16"; then
    NVIDIA_DRIVER_PACKAGE="nvidia-open-dkms"
else
    NVIDIA_DRIVER_PACKAGE="nvidia-dkms"
fi

# Select kernel headers based on the installed kernel.
KERNEL_HEADERS="linux-headers" # Default
if pacman -Q linux-zen &>/dev/null; then
    KERNEL_HEADERS="linux-zen-headers"
elif pacman -Q linux-lts &>/dev/null; then
    KERNEL_HEADERS="linux-lts-headers"
elif pacman -Q linux-hardened &>/dev/null; then
    KERNEL_HEADERS="linux-hardened-headers"
fi

# --- Package Installation ---
msg "Installing NVIDIA packages..."
nvidia_packages=(
    "${KERNEL_HEADERS}"
    "${NVIDIA_DRIVER_PACKAGE}"
    "nvidia-utils"
    "lib32-nvidia-utils"
    "egl-wayland"
    "libva-nvidia-driver" # For VA-API hardware acceleration
    "qt5-wayland"
    "qt6-wayland"
)
# The `install_packages` function uses the `--noconfirm` flag, which causes the installation to fail if there's a conflict.
# Replace the call to `install_packages` with a direct `yay` command for this specific set of packages.
# By removing `--noconfirm`, `yay` will prompt when it finds a conflict, and the `yes |` pipe will automatically answer "y" to it.
yes | yay -S --needed "${nvidia_packages[@]}"

# --- Kernel Module Configuration ---
msg "Configuring kernel modules for early KMS..."
echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf >/dev/null

msg "Configuring mkinitcpio for early module loading..."
MKINITCPIO_CONF="/etc/mkinitcpio.conf"
NVIDIA_MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

# Create a backup before modifying.
if [ -f "$MKINITCPIO_CONF" ]; then
    sudo cp "$MKINITCPIO_CONF" "${MKINITCPIO_CONF}.backup"
fi

# Remove existing nvidia modules to prevent duplicates, then add the new ones.
sudo sed -i -E 's/ nvidia_drm//g; s/ nvidia_uvm//g; s/ nvidia_modeset//g; s/ nvidia//g;' "$MKINITCPIO_CONF"
sudo sed -i -E "s/^(MODULES=\\()/\\1${NVIDIA_MODULES} /" "$MKINITCPIO_CONF"
sudo sed -i -E 's/  +/ /g' "$MKINITCPIO_CONF" # Clean up potential double spaces

msg "Rebuilding initramfs..."
sudo mkinitcpio -P

# --- Hyprland Environment Configuration ---
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
if [ -f "$HYPRLAND_CONF" ]; then
    # Check if variables are already present to avoid duplication.
    if ! grep -q "env = NVD_BACKEND,direct" "$HYPRLAND_CONF"; then
        msg "Adding NVIDIA environment variables to ${HYPRLAND_CONF}..."
        cat >> "$HYPRLAND_CONF" << 'EOF'

# NVIDIA environment variables
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
    else
        msg "NVIDIA environment variables already present in ${HYPRLAND_CONF}. Skipping."
    fi
else
    msg "Hyprland config not found at ${HYPRLAND_CONF}. Skipping."
fi
