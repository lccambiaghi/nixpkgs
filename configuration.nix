{ lib, config, pkgs, ... }:

with lib; {
  imports = attrValues (import ../../modules);
  networking.hostName = "macbook";

  # imports = [ <home-manager/nix-darwin> ];

  # home-manager.users.luca = import ./home.nix;

  # environment.systemPackages =
  #   [ pkgs.vim
  #   pkgs.gitAndTools.gitFull
  #   pkgs.aria
  #   ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.lorri.enable = true;
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
