# Installs and configures iwd, a modern Wi-Fi daemon.

msg "Installing 'iwd' for wireless networking..."
install_packages iwd impala

msg "Enabling iwd service..."
sudo systemctl enable iwd.service
