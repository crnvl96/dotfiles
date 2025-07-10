#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
stow_dir=$PWD

packages=()
for dir in */; do
  packages+=("${dir%/}")
done

command=(stow --verbose=2 -d "$stow_dir" --no-folding -t "$HOME" "${packages[@]}")

printf 'Command:'
printf ' %q' "${command[@]}"
printf '\n\nRun this command? [y/N] '
read -r answer
case "$answer" in
  [yY] | [yY][eE][sS])
    output_file=$(mktemp "${TMPDIR:-/tmp}/stow.output.XXXXXX")
    if "${command[@]}" >"$output_file" 2>&1; then
      printf 'Output written to: %s\n' "$output_file"
    else
      status=$?
      printf 'Output written to: %s\n' "$output_file"
      exit "$status"
    fi
    ;;
  *)
    echo "Aborted."
    ;;
esac
