# Installs Langs using 'mise'

if command_exists uv; then
  msg "uv is already installed."
else
  msg "Installing uv via mise..."
  msg "Installing and setting global uv version..."

  mise install uv
  mise use uv -g
fi

if command_exists ruby; then
  msg "Ruby is already installed."
else
  msg "Installing Ruby via mise..."

  # Install Ruby using gcc-14 for compatibility.
  msg "Installing gcc14 as a build dependency for Ruby..."
  install_packages gcc14

  msg "Configuring mise to use gcc-14 for Ruby builds..."
  mise settings set ruby.ruby_build_opts "CC=gcc-14 CXX=g++-14"

  msg "Installing and setting global Ruby version..."
  mise install ruby
  mise use ruby -g

  msg "Configuring mise to trust .ruby-version files..."
  mise settings add idiomatic_version_file_enable_tools ruby
fi


if command_exists rustc; then
  msg "Rust is already installed."
else
  msg "Installing Rust via mise..."
  msg "Installing and setting global Rust version..."

  mise install rust@nightly
  mise use rust -g
fi

if command_exists go; then
  msg "Golang is already installed."
else
  msg "Installing Golang via mise..."
  msg "Installing and setting global Golang version..."

  mise install go
  mise use go -g
fi

if command_exists node; then
  msg "Node is already installed."
else
  msg "Installing Node via mise..."
  msg "Installing and setting global Node version..."

  mise install node
  mise use node -g

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
fi
