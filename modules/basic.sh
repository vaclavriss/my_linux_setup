#!/usr/bin/env bash
# Basic system update and common packages

sudo apt update && sudo apt upgrade -y

# Git, wget, basic tools and some utilities used by other modules
sudo apt install -y zsh git wget unzip curl fzf xclip xdotool
