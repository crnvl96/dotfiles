# Installs Ruby using 'mise' with a specific compiler for compatibility.

if command_exists ruby; then
  msg "Ruby is already installed."
  return
fi

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
