# Installs system fonts and links custom fonts.

msg "Installing standard system fonts..."
font_packages=(
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

if ! fc-list | grep -qi "CaskaydiaMono Nerd Font"; then
  cd /tmp
  wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
  unzip CascadiaMono.zip -d CascadiaFont
  cp CascadiaFont/CaskaydiaMonoNerdFont-Regular.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-Bold.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-Italic.ttf ~/.local/share/fonts
  cp CascadiaFont/CaskaydiaMonoNerdFont-BoldItalic.ttf ~/.local/share/fonts
  rm -rf CascadiaMono.zip CascadiaFont
  fc-cache
  cd -
fi
