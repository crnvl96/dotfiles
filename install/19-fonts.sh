yay -Sy --noconfirm --needed ttf-font-awesome noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra

mkdir -p ~/.local/share/fonts

if [ ! -d "$HOME/.local/share/fonts/Berkeley Mono" ]; then
    ln -snf "$HOME/.local/share/dotfiles/fonts/Berkeley Mono" "$HOME/.local/share/fonts/"
    fc-cache
fi
