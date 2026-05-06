#!/bin/bash

set -euo pipefail

# Bootstrap: determine repo paths and common helpers, then source modules

# Get the directory where this script is located
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$REPO_DIR/dot_files"

copy_file_if_exists() {
	local src="$1"
	local dst="$2"

	if [[ -f "$src" ]]; then
		mkdir -p "$(dirname "$dst")"
		cp "$src" "$dst"
	else
		echo "ERROR: source file does not exist: $src" >&2
	fi
}

copy_dir_if_exists() {
	local src_dir="$1"
	local dst_dir="$2"

	if [[ -d "$src_dir" ]]; then
		mkdir -p "$dst_dir"
		cp -a "$src_dir"/. "$dst_dir"/
	else
		echo "ERROR: source directory does not exist: $src_dir" >&2
	fi
}

export REPO_DIR DOTFILES_DIR

MODULE_DIR="$REPO_DIR/modules"
if [[ ! -d "$MODULE_DIR" ]]; then
	echo "No modules directory found at $MODULE_DIR. Nothing to run." >&2
	exit 1
fi

echo "Running modular install from $MODULE_DIR"

# Explicit, ordered module execution (most important -> less important)
if [[ -r "$MODULE_DIR/basic.sh" ]]; then
	echo "---- Running module: basic.sh ----"
	# shellcheck source=/dev/null
	source "$MODULE_DIR/basic.sh"
else
	echo "Skipping missing module: basic.sh" >&2
fi

if [[ -r "$MODULE_DIR/zsh.sh" ]]; then
	echo "---- Running module: zsh.sh ----"
	# shellcheck source=/dev/null
	source "$MODULE_DIR/zsh.sh"
else
	echo "Skipping missing module: zsh.sh" >&2
fi

if [[ -r "$MODULE_DIR/pet.sh" ]]; then
	echo "---- Running module: pet.sh ----"
	# shellcheck source=/dev/null
	source "$MODULE_DIR/pet.sh"
else
	echo "Skipping missing module: pet.sh" >&2
fi

if [[ -r "$MODULE_DIR/nvim.sh" ]]; then
	echo "---- Running module: nvim.sh ----"
	# shellcheck source=/dev/null
	source "$MODULE_DIR/nvim.sh"
else
	echo "Skipping missing module: nvim.sh" >&2
fi

if [[ -r "$MODULE_DIR/git-tmux.sh" ]]; then
	echo "---- Running module: git-tmux.sh ----"
	# shellcheck source=/dev/null
	source "$MODULE_DIR/git-tmux.sh"
else
	echo "Skipping missing module: git-tmux.sh" >&2
fi

if [[ -r "$MODULE_DIR/sway.sh" ]]; then
	echo "---- Running module: sway.sh ----"
	# shellcheck source=/dev/null
	source "$MODULE_DIR/sway.sh"
else
	echo "Skipping missing module: sway.sh" >&2
fi

if [[ -r "$MODULE_DIR/yazi.sh" ]]; then
	echo "---- Running module: yazi.sh ----"
	# shellcheck source=/dev/null
	source "$MODULE_DIR/yazi.sh"
else
echo "Skipping missing module: yazi.sh" >&2
fi

if [[ -r "$MODULE_DIR/utils.sh" ]]; then
	echo "---- Running module: utils.sh ----"
	# shellcheck source=/dev/null
	source "$MODULE_DIR/utils.sh"
else
	echo "Skipping missing module: utils.sh" >&2
fi

echo "All modules completed."
