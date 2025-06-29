backup="$HOME/.local/share/dotfiles.bak"
repo="$HOME/.local/share/dotfiles"

echo -e "\nInstalling dotfiles...\n"

pacman -Q git &>/dev/null || sudo pacman -Sy --noconfirm --needed git

echo -e "\nCloning dotfiles..."

if [ -d "$repo" ]; then
    mv "$repo" "$backup"
fi

if git clone https://github.com/crnvl96/dotfiles.git "$repo" >/dev/null; then
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
