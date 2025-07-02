# Installs common development tools and runtimes.

msg "Installing development tools..."

dev_packages=(
  # Build tools and compilers
  "cargo" "clang" "llvm"

  # Version management
  "mise"

  # Libraries and utilities
  "imagemagick"
  "mariadb-libs" "postgresql-libs"
  "github-cli"

  # TUI applications
  "lazygit" "lazydocker" "diff-so-fancy" # prettier git diff
)

install_packages "${dev_packages[@]}"
