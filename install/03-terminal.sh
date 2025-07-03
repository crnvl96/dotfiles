# Installs essential Command-Line Interface (CLI) tools.

msg "Installing essential CLI tools..."

cli_packages=(
  # Core utilities
  "wget" "curl" "unzip" "inetutils"

  # Modern replacements
  "fd"        # 'find' replacement
  "eza"       # 'ls' replacement
  "fzf"       # Command-line fuzzy finder
  "ripgrep"   # 'grep' replacement
  "zoxide"    # 'cd' replacement
  "bat"       # 'cat' replacement with syntax highlighting

  # System and info tools
  "wl-clipboard" # Wayland clipboard utilities
  "fastfetch"    # System information tool
  "btop"         # Resource monitor
  "man" "tldr" "less" "whois" "plocate"

  # Terminal Emulator
  "ghostty"
)

install_packages "${cli_packages[@]}"
