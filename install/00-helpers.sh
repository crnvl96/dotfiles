# Contains helper functions for all other installation scripts.
# Sourced by the main install.sh script.
# The '00' prefix ensures it is loaded first.

# --- Terminal Colors ---
readonly C_RESET='\033[0m'
readonly C_BOLD='\033[1m'
readonly C_GREEN='\033[0;32m'
readonly C_BLUE='\033[0;34m'

# --- Helper Functions ---

# Prints a formatted message.
#
# Arguments:
#   $1: The message to print.
msg() {
  echo -e "${C_BOLD}${C_BLUE}==>${C_RESET}${C_BOLD} $1${C_RESET}"
}

# Installs packages using yay.
#
# Arguments:
#   $@: A list of packages to install.
install_packages() {
  # The --needed flag prevents re-installation of already-up-to-date packages.
  # The --noconfirm flag bypasses confirmation prompts.
  yay -S --noconfirm --needed "$@"
}

# Checks if a command exists.
#
# Arguments:
#   $1: The command to check.
#
# Returns:
#   0 if the command exists, 1 otherwise.
command_exists() {
  command -v "$1" &>/dev/null
}
