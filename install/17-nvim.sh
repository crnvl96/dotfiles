# Installs Neovim and related dependencies.

if command_exists nvim; then
  msg "Neovim is already installed."
  return
fi

msg "Installing Neovim and dependencies..."
nvim_packages=(
  "nvim"
  "luarocks"        # Package manager for Lua modules
  "tree-sitter-cli" # For generating parsers
)
install_packages "${nvim_packages[@]}"


# Capture the installed Node.js version using mise ls -g
NODE_VERSION=$(mise ls -g | grep '^node' | awk '{print $2}')
msg "Detected Node.js version: $NODE_VERSION"

# Prepend the content to init.lua in .config/nvim/ using tee and EOF
msg "Updating nvim init.lua with Node.js path..."

INIT_LUA_PATH="$HOME/.config/nvim/init.lua"
TEMP_FILE=$(mktemp)

cat "$INIT_LUA_PATH" > "$TEMP_FILE"

tee "$INIT_LUA_PATH" >/dev/null <<EOF
local HOME = os.getenv('HOME')
local default_nodejs = HOME .. '/.local/share/mise/installs/node/$NODE_VERSION/bin/'
vim.g.node_host_prog = default_nodejs .. 'node'
vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH

EOF

cat "$TEMP_FILE" >> "$INIT_LUA_PATH"
rm "$TEMP_FILE"
msg "Updated nvim init.lua with Node.js version $NODE_VERSION"
