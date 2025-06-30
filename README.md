# Acknowledgements

These dotfiles were originally forked from [omarchy](https://omarchy.org/), but have since been heavily modified and now exist independently since [671f9c7882394a6582c99b42bd867762bf6a7a46](https://github.com/crnvl96/dotfiles/commit/671f9c7882394a6582c99b42bd867762bf6a7a46).

## Installation

1. **Install Arch Linux First**:
   - Download the [Arch Linux ISO](https://archlinux.org/download/#http-downloads)
   - Boot into the installer.
   - If using Wi-Fi:
     - connect with `iwctl`:

       ```bash
       iwctl
       station wlan0 connect <tab>
       ```

     - Select your network and enter the password.
     - Ethernet users can skip this step.

   - Run `archinstall` to set up Arch Linux with the following configurations:

     ```base
     archinstall
     ```

     - **Disk Encryption**: Select `LUKS`, set a password, and apply to the partition. This is important for security, since auto-login is made after decryption.
     - **Audio**: Select `pipewire`.
     - **Network**: Choose `Copy ISO network configuration`.
     - **Additional Packages**: Add `wget`.
     - **Other Configurations**:
       - timezone
       - hostname
       - root password
       - user
     - Leave other settings as default.

   - Reboot after installation.

2. **Install Dotfiles**:
   - Log in with the user account created during Arch setup.
   - Run the installer:
     ```bash
     wget -qO- https://crnvl96.dev/dotfiles | bash
     ```

3. **Additional Steps for Nvidia GPU Users**:
   - After running the Omarchy installer, and before rebooting, install Nvidia-specific packages:
     ```bash
     sudo pacman -S nvidia-utils libva-nvidia-driver nvidia-dkms
     ```
   - Edit `~/.config/hypr/hyprland.conf` to uncomment the following environment variables:
     ```bash
     # env = NVD_BACKEND,direct
     # env = LIBVA_DRIVER_NAME,nvidia
     # env = __GLX_VENDOR_LIBRARY_NAME,nvidia
     ```
   - Note: Automation for Nvidia setup is planned via an [open issue](https://github.com/basecamp/omarchy/issues/4).
