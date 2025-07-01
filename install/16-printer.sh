# Installs and configures CUPS for printing support.

msg "Installing CUPS printing service..."
printer_packages=(
  "cups"
  "cups-pdf"
  "cups-filters"
  "system-config-printer"
)
install_packages "${printer_packages[@]}"

msg "Enabling and starting CUPS service..."
sudo systemctl enable --now cups.service
