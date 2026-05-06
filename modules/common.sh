#!/usr/bin/env bash
set -euo pipefail

# Common helpers and environment for module scripts.
# When a module is run directly, source this file to get
# `REPO_DIR`, `DOTFILES_DIR` and utility functions.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
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
