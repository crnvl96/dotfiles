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
fi
