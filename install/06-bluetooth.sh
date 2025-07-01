# Installs and configures Bluetooth support.

msg "Installing Bluetooth tools..."
install_packages blueberry

msg "Enabling and starting Bluetooth service..."
sudo systemctl enable --now bluetooth.service
