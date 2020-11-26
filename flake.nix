{
  description = "Luca Cambiaghi's darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "";
    };
    # inputs.emacs-pgtk-overlay = {
    #   url = "github:mjlbach/emacs-pgtk-nativecomp-overlay";
    #   flake = false;
    # };
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }: {
    darwinConfigurations."Johns-MacBook" = darwin.lib.darwinSystem {
      modules = [
          ./modules/config.nix
          ./modules/homebrew.nix
      ];
    };
  };
}
