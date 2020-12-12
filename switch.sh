#!/bin/zsh
# nix-shell --run "home-manager switch"
darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
# /run/current-system/sw/bin/darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
