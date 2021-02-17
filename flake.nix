{
  description = "Luca Cambiaghi's darwin configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    nur.url = "github:nix-community/NUR";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-utils.url = "github:numtide/flake-utils";
    gccemacs-darwin = {
      type = "github";
      owner = "twlz0ne";
      repo = "nix-gccemacs-darwin";
      ref = "master";
      flake = false;
    };
    # emacs-overlay = {
    #   type = "github";
    #   owner = "mjlbach";
    #   repo = "emacs-overlay";
    #   ref = "feature/flakes";
    # };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    {
    darwinConfigurations."luca-macbookpro" = darwin.lib.darwinSystem {
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
      ];
      specialArgs = { inherit inputs nixpkgs; };
    };
  };
}
