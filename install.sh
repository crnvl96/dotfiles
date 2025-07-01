# install.sh - Main installer for all components.
#
# This script sources all shell scripts within the 'install' directory
# in alphanumeric order to set up the system. It assumes that 'boot.sh'
# has already been run.

set -euo pipefail

INSTALL_DIR="$(dirname "$0")/install"

# Source helper functions first. It must be named '00-helpers.sh' to be sourced first.
if [ -f "$INSTALL_DIR/00-helpers.sh" ]; then
  source "$INSTALL_DIR/00-helpers.sh"
else
  echo "ERROR: Helper script '00-helpers.sh' not found. Aborting." >&2
  exit 1
fi

msg "Starting system setup..."

# Execute all installation scripts in order.
for script in "$INSTALL_DIR"/*.sh; do
  if [ -f "$script" ]; then
    msg "Running $(basename "$script")..."
    source "$script"
  fi
done

msg "All installation scripts have been executed."

# The 'locate' command uses a database of files on the system.
# We update it now so it's aware of all the newly installed files.
msg "Updating 'locate' database..."
sudo updatedb

msg "System setup complete!"

# Prompt for a reboot to ensure all settings, services, and kernel
# modules are loaded correctly.
if gum confirm "Reboot to apply all settings?"; then
  reboot
else
  msg "Reboot skipped. Please reboot manually to apply all changes."
fi
