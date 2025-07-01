# Downloads background images defined in theme files.

BACKGROUNDS_DIR=~/.config/dotfiles/backgrounds/

# Defines a function to download an image with a spinner for user feedback.
# This function is expected to be called by the scripts sourced below.
download_background_image() {
  local url="$1"
  local path="$2"
  gum spin --title "Downloading $url as $path..." -- curl -sL -o "$BACKGROUNDS_DIR/$path" "$url"
}

msg "Sourcing theme background scripts to download images..."
for t in ~/.local/share/dotfiles/themes/*; do
  if [ -f "$t/backgrounds.sh" ]; then
    source "$t/backgrounds.sh"
  fi
done
