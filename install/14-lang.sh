# Installs Langs using 'mise'

# Install Ruby using gcc-14 for compatibility.
msg "Installing gcc14 as a build dependency for Ruby..."
install_packages gcc14

msg "Configuring mise to use gcc-14 for Ruby builds..."
mise settings set ruby.ruby_build_opts "CC=gcc-14 CXX=g++-14"

msg "Configuring mise to trust .ruby-version files..."
mise settings add idiomatic_version_file_enable_tools ruby

UV_INSTALLED=$(mise ls -g | grep -E '^uv')
if [ -n "$UV_INSTALLED" ]; then
  msg "uv is already installed."
else
  msg "Installing uv via mise..."
  msg "Installing and setting global uv version..."

  mise install uv
  mise use uv -g
fi

RUST_INSTALLED=$(mise ls -g | grep -E '^rust')
if [ -n "$RUST_INSTALLED" ]; then
  msg "Rust is already installed via mise. Version: $RUST_VERSION"
else
  msg "Rust is not installed via mise. Installing Rust..."
  msg "Installing and setting global Rust version..."

  mise install rust@nightly
  mise use rust@nightly -g
fi

GO_INSTALLED=$(mise ls -g | grep -E '^go')
if [ -n "$GO_INSTALLED" ]; then
  msg "Golang is already installed."
else
  msg "Installing Golang via mise..."
  msg "Installing and setting global Golang version..."

  mise install go
  mise use go -g
fi

NODE_INSTALLED=$(mise ls -g | grep -E '^node')
if [ -n "$NODE_INSTALLED" ]; then
  msg "Node is already installed."
else
  msg "Installing Node via mise..."
  msg "Installing and setting global Node version..."

  mise install node
  mise use node -g
fi
