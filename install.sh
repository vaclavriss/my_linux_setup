#!/bin/bash

set -euo pipefail

# Bootstrap: determine repo paths and source shared helpers

# Get the directory where this script is located
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$REPO_DIR/modules/common.sh"

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
	source "$MODULE_DIR/sway-waybar-wofi.sh"
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
