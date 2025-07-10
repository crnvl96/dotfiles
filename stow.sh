#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
stow_dir=$PWD

# Packages that install outside $HOME (system-wide). These are stowed with
# sudo into the given target instead of into $HOME.
# Format: "package:target"
system_packages=(
  "keyd:/etc/keyd"
)

usage() {
  local sys_names=() entry
  for entry in "${system_packages[@]}"; do sys_names+=("${entry%%:*} -> ${entry#*:}"); done
  cat <<EOF
Usage: $0 [OPTIONS]

Stow all dotfiles packages. User packages are stowed into \$HOME; system
packages are stowed into their system targets with sudo:

$(printf '  %s\n' "${sys_names[@]}")

node_modules/ is never stowed (managed by the runtime, e.g. pnpm).

Options:
  --fresh    Unstow all packages first, then restow (clean slate)
  -h, --help Show this help message and exit

Packages found in: $stow_dir
EOF
}

# Print the system target for a package name, or return 1 if it is a user package.
system_target() {
  local pkg=$1 entry
  for entry in "${system_packages[@]}"; do
    if [[ "${entry%%:*}" == "$pkg" ]]; then
      printf '%s\n' "${entry#*:}"
      return 0
    fi
  done
  return 1
}

# Print a command, ask for confirmation, run it, and capture output to a temp
# file (path printed on success or failure).
run_confirmed() {
  local cmd=("$@")
  printf 'Command:'
  printf ' %q' "${cmd[@]}"
  printf '\n\nRun this command? [y/N] '
  local answer
  read -r answer
  case "$answer" in
    [yY] | [yY][eE][sS]) ;;
    *)
      echo "Aborted."
      return 1
      ;;
  esac
  local output_file status
  output_file=$(mktemp "${TMPDIR:-/tmp}/stow.output.XXXXXX")
  if "${cmd[@]}" >"$output_file" 2>&1; then
    printf 'Output written to: %s\n' "$output_file"
  else
    status=$?
    printf 'Output written to: %s\n' "$output_file"
    return "$status"
  fi
}

fresh=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --fresh)
      fresh=true
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Run '$0 --help' for usage." >&2
      exit 1
      ;;
  esac
done

# Discover packages (one top-level directory each).
all_packages=()
for dir in */; do
  all_packages+=("${dir%/}")
done

if [[ ${#all_packages[@]} -eq 0 ]]; then
  echo "No packages found to stow." >&2
  exit 1
fi

# Split into user (-> $HOME) and system (-> sudo target) packages.
user_packages=()
system_pkgs=()
for pkg in "${all_packages[@]}"; do
  if system_target "$pkg" >/dev/null; then
    system_pkgs+=("$pkg")
  else
    user_packages+=("$pkg")
  fi
done

# Common stow flags. --no-folding symlinks individual files instead of folding
# whole directories; --ignore keeps generated/runtime trees (e.g. node_modules)
# out of $HOME so the runtime owns them.
stow_common=(--verbose=2 --no-folding --ignore='node_modules' -d "$stow_dir")

if "$fresh"; then
  printf 'Fresh mode: unstowing first\n\n'
  if [[ ${#user_packages[@]} -gt 0 ]]; then
    run_confirmed stow "${stow_common[@]}" -t "$HOME" -D "${user_packages[@]}"
  fi
  if [[ ${#system_pkgs[@]} -gt 0 ]]; then
    for pkg in "${system_pkgs[@]}"; do
      target=$(system_target "$pkg")
      run_confirmed sudo stow "${stow_common[@]}" -t "$target" -D "$pkg"
    done
  fi
  printf '\n'
fi

if [[ ${#user_packages[@]} -gt 0 ]]; then
  run_confirmed stow "${stow_common[@]}" -t "$HOME" -R "${user_packages[@]}"
fi
if [[ ${#system_pkgs[@]} -gt 0 ]]; then
  for pkg in "${system_pkgs[@]}"; do
    target=$(system_target "$pkg")
    run_confirmed sudo stow "${stow_common[@]}" -t "$target" -R "$pkg"
  done
fi
