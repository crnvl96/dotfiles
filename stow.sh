#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
stow_dir=$PWD

# Keep this list explicit so adding an unrelated top-level directory does not
# automatically make it a Stow package.
common_packages=(
  bin
  git
  lazygit
  mise
  ripgrep
  shell
)

# Packages that install outside $HOME (system-wide). These are stowed with
# sudo into the given target instead of into the user's home directory.
# Format: "package:target"
system_package_targets=()
case "$(uname -s)" in
  Linux)
    shell_package=bash
    platform_packages=(bash kitty keyd)
    system_package_targets=("keyd:/etc/keyd")
    ;;
  Darwin)
    shell_package=zsh
    platform_packages=(ghostty zsh)
    ;;
  *)
    echo "Unsupported operating system: $(uname -s)" >&2
    exit 1
    ;;
esac

all_packages=("${platform_packages[@]}" "${common_packages[@]}")

usage() {
  local sys_names=() entry
  if ((${#system_package_targets[@]} > 0)); then
    for entry in "${system_package_targets[@]}"; do
      sys_names+=("${entry%%:*} -> ${entry#*:}")
    done
  fi
  cat <<EOF
Usage: $0 [OPTIONS]

Stow dotfiles packages for $(uname -s). The active shell package is
'$shell_package'. User packages are stowed into \$HOME; system packages
are stowed into their system targets with sudo.

EOF
  if ((${#sys_names[@]} > 0)); then
    printf '  %s\n' "${sys_names[@]}"
  else
    printf '  (none)\n'
  fi
  cat <<EOF

Packages: ${all_packages[*]}

Options:
  --dry-run  Show what Stow would do without changing any files
  -y, --yes  Skip confirmation prompts (sudo may still ask for a password)
  -h, --help Show this help message and exit

Generated node_modules/ directories are never stowed.
Packages are defined explicitly in this script.
Packages found in: $stow_dir
EOF
}

# Print the system target for a package name, or return 1 if it is a user package.
system_target() {
  local pkg="$1" entry
  if ((${#system_package_targets[@]} == 0)); then
    return 1
  fi
  for entry in "${system_package_targets[@]}"; do
    if [[ "${entry%%:*}" == "$pkg" ]]; then
      printf '%s\n' "${entry#*:}"
      return 0
    fi
  done
  return 1
}

require_command() {
  local command_name="$1"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$command_name" >&2
    return 1
  fi
}

# Print a command, optionally ask for confirmation, stream its output, and
# retain the output in a temporary file only when the command fails.
run_command() {
  local cmd=("$@")
  printf 'Command:'
  printf ' %q' "${cmd[@]}"
  printf '\n'

  if [[ "$dry_run" == true ]]; then
    printf 'Dry run: no changes will be made.\n'
  elif [[ "$assume_yes" == true ]]; then
    printf 'Skipping confirmation (--yes).\n'
  else
    printf '\nRun this command? [y/N] '
    local answer
    if ! read -r answer; then
      echo "Aborted."
      return 1
    fi
    case "$answer" in
      [yY] | [yY][eE][sS]) ;;
      *)
        echo "Aborted."
        return 1
        ;;
    esac
  fi

  local output_file
  output_file=$(mktemp "${TMPDIR:-/tmp}/stow.output.XXXXXX")

  local -a pipeline_status
  # Keep the pipeline in an if condition so set -e does not exit before
  # PIPESTATUS can be captured.
  if "${cmd[@]}" 2>&1 | tee "$output_file"; then
    pipeline_status=("${PIPESTATUS[@]}")
  else
    pipeline_status=("${PIPESTATUS[@]}")
  fi

  local command_status=${pipeline_status[0]}
  local tee_status=${pipeline_status[1]}
  if ((command_status == 0 && tee_status == 0)); then
    rm -f "$output_file"
    return 0
  fi

  local status=$command_status
  if ((status == 0)); then
    status=$tee_status
  fi
  printf 'Command failed with status %d; output saved to: %s\n' \
    "$status" "$output_file" >&2
  return "$status"
}

dry_run=false
assume_yes=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    -y | --yes)
      assume_yes=true
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

if [[ ! -d "$stow_dir/$shell_package" ]]; then
  echo "Missing shell package for this OS: $shell_package" >&2
  exit 1
fi

for pkg in "${all_packages[@]}"; do
  if [[ ! -d "$stow_dir/$pkg" ]]; then
    echo "Missing Stow package: $pkg" >&2
    exit 1
  fi
done

require_command stow
require_command mktemp
require_command tee
if ((${#system_package_targets[@]} > 0)) && [[ "$dry_run" == false ]]; then
  require_command sudo
fi

# Split into user (-> $HOME) and system (-> system target) packages.
user_packages=()
selected_system_packages=()
for pkg in "${all_packages[@]}"; do
  if system_target "$pkg" >/dev/null; then
    selected_system_packages+=("$pkg")
  else
    user_packages+=("$pkg")
  fi
done

# Common Stow flags. --no-folding symlinks individual files instead of folding
# whole directories; --ignore keeps generated/runtime trees (e.g. node_modules)
# out of $HOME. --no is added for --dry-run.
stow_common=(--verbose=2 --no-folding --ignore='node_modules' -d "$stow_dir")
if [[ "$dry_run" == true ]]; then
  stow_common+=(--no)
fi

if ((${#user_packages[@]} > 0)); then
  run_command stow "${stow_common[@]}" -t "$HOME" -R "${user_packages[@]}"
fi

if ((${#selected_system_packages[@]} > 0)); then
  for pkg in "${selected_system_packages[@]}"; do
    target=$(system_target "$pkg")
    if [[ "$dry_run" == true ]]; then
      # A dry run does not need elevated privileges and should not prompt for
      # a sudo password merely to inspect the planned changes.
      run_command stow "${stow_common[@]}" -t "$target" -R "$pkg"
    else
      run_command sudo stow "${stow_common[@]}" -t "$target" -R "$pkg"
    fi
  done
fi
