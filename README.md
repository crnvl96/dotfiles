# Acknowledgements

These dotfiles were originally forked from [omarchy](https://omarchy.org/), but have since been heavily modified and now exist independently.

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

## How do I get rid of all the extra software?

For packages

```bash
yay -Qe | grep -i <package_name>
yay -Rns <package_name>
```
