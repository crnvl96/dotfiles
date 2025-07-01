backup="$HOME/.local/share/dotfiles.bak"
repo="$HOME/.local/share/dotfiles"

echo -e "\nInstalling dotfiles...\n"

### Enable Multilib (for steam) ###
# https://wiki.archlinux.org/title/Official_repositories#multilib
if grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Multilib repository is already enabled."
else
    sudo tee -a /etc/pacman.conf >/dev/null <<EOF

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
    echo "Multilib repository has been enabled in /etc/pacman.conf."
fi

pacman -Q git &>/dev/null || sudo pacman -Syu --noconfirm --needed git

echo -e "\nCloning dotfiles..."

if [ -d "$repo" ]; then
    mv "$repo" "$backup"
fi

if git clone https://github.com/crnvl96/dotfiles.git "$repo" >/dev/null; then
    cd "$repo"
    git remote set-url origin git@github.com:crnvl96/dotfiles.git
    cd - >/dev/null
    rm -rf "$backup"
else
    echo "Clone failed, restoring backup..."
    rm -rf "$repo"
    if [ -d "$backup" ]; then
        mv "$backup" "$repo"
    fi
    exit 1
fi

echo -e "\nInstallation starting..."

source "$repo/install.sh"
