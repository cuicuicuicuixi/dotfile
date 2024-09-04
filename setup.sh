#!/bin/bash

# Set up XDG_CONFIG_HOME
export XDG_CONFIG_HOME="$HOME"/.config
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CONFIG_HOME"/nixpkgs

cp -r "$PWD/config" "$XDG_CONFIG_HOME/"

ln -sf "$PWD/.zshrc" "$HOME/"

nix-env -iA nixpkgs.myPackages

chsh -s "$(which zsh)"

zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
