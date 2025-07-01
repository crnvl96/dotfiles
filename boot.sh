# boot.sh - Initial setup script for the dotfiles.
#
# This script performs the following actions:
# 1. Enables the multilib repository for 32-bit package support (e.g., Steam).
# 2. Installs Git if it is not already present.
# 3. Clones/updates the dotfiles repository from GitHub.
# 4. Executes the main installation script (install.sh).

set -euo pipefail # Exit on error, undefined variable, or pipe failure.

REPO_DIR="$HOME/.local/share/dotfiles"
REPO_BACKUP_DIR="$HOME/.local/share/dotfiles.bak"
REPO_URL="https://github.com/crnvl96/dotfiles.git"
REPO_SSH_URL="git@github.com:crnvl96/dotfiles.git"

# Helper for printing messages, as helpers script is not yet available.
_msg() {
  echo -e "\n\033[1;34m=>\033[0;1m $1\033[0m"
}

# --- Main Logic ---

if [ "$PWD" != "$HOME" ]; then
  _msg "ERROR: Please run this script from your home directory (\$HOME: $HOME). Current directory: $PWD." >&2
  exit 1
fi

_msg "Starting dotfiles installation..."

# Step 1: Enable Multilib repository in pacman.conf
# The multilib repository is required for running 32-bit applications on a 64-bit system.
_msg "Ensuring 'multilib' repository is enabled..."
if ! grep -q "^\\[multilib\\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo tee -a /etc/pacman.conf >/dev/null <<EOF

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
    echo "Multilib repository enabled. Syncing package databases..."
    sudo pacman -Syu --noconfirm
else
    echo "Multilib repository is already enabled."
fi

# Step 2: Ensure Git is installed
_msg "Checking for Git..."
if ! command -v git &>/dev/null; then
    echo "Git not found. Installing..."
    sudo pacman -S --noconfirm --needed git
else
    echo "Git is already installed."
fi

# Step 3: Clone the dotfiles repository
_msg "Cloning dotfiles repository from ${REPO_URL}..."
if [ -d "$REPO_DIR" ]; then
    echo "Existing dotfiles directory found. Moving to ${REPO_BACKUP_DIR}."
    mv -f "$REPO_DIR" "$REPO_BACKUP_DIR"
fi

if git clone "$REPO_URL" "$REPO_DIR"; then
    echo "Repository cloned successfully."
    cd "$REPO_DIR"
    echo "Setting remote URL to use SSH for future pulls/pushes."
    git remote set-url origin "$REPO_SSH_URL"
    cd - >/dev/null
    rm -rf "$REPO_BACKUP_DIR"
else
    echo "ERROR: Git clone failed." >&2
    if [ -d "$REPO_BACKUP_DIR" ]; then
        echo "Restoring backup from ${REPO_BACKUP_DIR}."
        mv -f "$REPO_BACKUP_DIR" "$REPO_DIR"
    fi
    exit 1
fi

# Step 4: Run the main installer
_msg "Executing the main installation script..."
source "$REPO_DIR/install.sh"

echo
_msg "Dotfiles installation process finished."
