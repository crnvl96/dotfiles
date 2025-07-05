# Installs and configures power management profiles.

msg "Installing power-profiles-daemon..."
install_packages power-profiles-daemon

# This check determines if the system has a battery.
if ls /sys/class/power_supply/BAT* &>/dev/null; then
  msg "Battery detected. Setting power profile to 'balanced'."
  powerprofilesctl set balanced || true
else
  msg "No battery detected. Setting power profile to 'performance'."
  powerprofilesctl set performance || true
fi
