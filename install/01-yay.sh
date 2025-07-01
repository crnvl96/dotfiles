# Installs 'base-devel' and the 'yay' AUR helper, which is required
# to install packages from the Arch User Repository (AUR).

msg "Installing 'base-devel' group for package building..."
sudo pacman -S --needed --noconfirm base-devel

if command_exists yay; then
  msg "'yay' AUR helper is already installed."
  return
fi

msg "Installing 'yay' AUR helper..."

# It's safer to build packages in a temporary directory.
# We use 'mktemp' to create one and 'trap' to ensure it's cleaned up on exit.
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir"
(
  cd "$tmp_dir"
  # 'makepkg -s' installs dependencies.
  # 'makepkg -i' installs the built package.
  makepkg -si --noconfirm
)
