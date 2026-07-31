#!/usr/bin/env bash

# Use strict Bash behavior: stop on errors, reject unset variables, and fail a
# pipeline when any command in it fails. Individual exceptions are handled
# explicitly below where the script needs to inspect a command's exit status.
set -euo pipefail

# Stow package paths are relative to this script, not to the directory from
# which the user invokes it. Changing directory here also makes the -d path
# passed to Stow deterministic.
cd "$(dirname "${BASH_SOURCE[0]}")"
stow_dir=$PWD

# Each directory listed here is a Stow package. Keeping the list explicit
# prevents an unrelated top-level directory from being treated as a package.
common_packages=(
	bin
	git
	lazygit
	mise
	ripgrep
	shell
)

# Most packages are linked into the user's home directory. Packages listed
# here are exceptions: their contents belong outside $HOME and must be stowed
# into the target shown after the colon. Format: "package:target".
system_package_targets=()

# Select the platform-specific packages. The shell package is kept separate
# because it is also used in the help text and in the validation below. The
# package names must match directories next to this script.
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

# Stow every platform package as well as the packages shared by all platforms.
# Bash and zsh are mutually exclusive here because only the active platform's
# shell package is included.
all_packages=("${platform_packages[@]}" "${common_packages[@]}")

# Print the available options and the package/target selection made for this
# operating system. Keeping this in a function lets --help exit before any
# dependency checks or filesystem changes are attempted.
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

# Look up the non-home target for a package. A successful lookup means the
# package needs special handling (and normally sudo); a failed lookup means it
# is an ordinary package that should be stowed into $HOME.
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

# Fail early with a readable message instead of letting a missing dependency
# produce a less useful error later in the script.
require_command() {
	local command_name="$1"
	if ! command -v "$command_name" >/dev/null 2>&1; then
		printf 'Required command not found: %s\n' "$command_name" >&2
		return 1
	fi
}

# Run one Stow (or sudo Stow) command consistently. The command is printed so
# the user can review it, and interactive runs require confirmation unless
# --yes was supplied. In --dry-run mode Stow still runs, but its --no flag
# prevents changes from being made.
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

	# Capture normal command output on screen while retaining it if either the
	# command or tee fails. The temporary file is removed after success.
	local output_file
	output_file=$(mktemp "${TMPDIR:-/tmp}/stow.output.XXXXXX")

	local -a pipeline_status
	# Keep the pipeline in an if condition so set -e does not exit before
	# PIPESTATUS can be captured. PIPESTATUS[0] is the Stow command and
	# PIPESTATUS[1] is tee, so both failures can be reported accurately.
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

# Parse options before checking packages or dependencies. These flags affect
# both confirmation behavior and whether Stow is allowed to modify anything.
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

# Validate the package layout before invoking Stow. A missing directory usually
# indicates an incomplete checkout or a package name that was added to the
# arrays without adding the corresponding directory.
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

# Split the selected packages by destination. User packages can be combined
# into one Stow invocation, while system packages are handled individually so
# each one can use its own target directory.
user_packages=()
selected_system_packages=()
for pkg in "${all_packages[@]}"; do
	if system_target "$pkg" >/dev/null; then
		selected_system_packages+=("$pkg")
	else
		user_packages+=("$pkg")
	fi
done

# Build the flags shared by every Stow invocation:
#   --verbose=2  show enough detail to review the links being created
#   --no-folding  link individual files instead of folding whole directories
#   --ignore      keep generated/runtime trees such as node_modules unmanaged
#   -d            tell Stow where the package directories live
# Stow's --no option is added for --dry-run; run_command still displays and
# executes the planned command so the user can inspect Stow's output.
stow_common=(--verbose=2 --no-folding --ignore='node_modules' -d "$stow_dir")
if [[ "$dry_run" == true ]]; then
	stow_common+=(--no)
fi

# Link all home-directory packages into the user's home. -R means restow: Stow
# removes stale links for the selected packages and then creates the current
# ones. The explicit -t target avoids relying on Stow's default target rules.
if ((${#user_packages[@]} > 0)); then
	run_command stow "${stow_common[@]}" -t "$HOME" -R "${user_packages[@]}"
fi

# System packages cannot be combined with home packages because each target may
# be different. Real system changes use sudo; dry runs deliberately do not, so
# inspecting the plan never prompts for a password.
if ((${#selected_system_packages[@]} > 0)); then
	for pkg in "${selected_system_packages[@]}"; do
		# Resolve the target again here so the command is built from the same
		# package-to-target mapping used during classification.
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
