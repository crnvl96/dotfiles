# Installs Neovim and related dependencies.

if command_exists nvim; then
  msg "Neovim is already installed."
  return
fi

msg "Installing Neovim and dependencies..."
local -a nvim_packages=(
  "nvim"
  "luarocks"        # Package manager for Lua modules
  "tree-sitter-cli" # For generating parsers
)
install_packages "${nvim_packages[@]}"
