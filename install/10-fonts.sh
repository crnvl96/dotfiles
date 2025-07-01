# Installs system fonts and links custom fonts.

msg "Installing standard system fonts..."
local -a font_packages=(
  "ttf-font-awesome"
  "noto-fonts"
  "noto-fonts-emoji"
  "noto-fonts-cjk"
  "noto-fonts-extra"
)
install_packages "${font_packages[@]}"

msg "Installing custom fonts..."
mkdir -p ~/.local/share/fonts

if [ ! -d "$HOME/.local/share/fonts/Berkeley Mono" ]; then
    msg "Linking Berkeley Mono font..."
    ln -snf "$HOME/.local/share/dotfiles/fonts/Berkeley Mono" "$HOME/.local/share/fonts/"
    # Update the font cache to make the new font available.
    fc-cache -f
fi
