# NOTE: this file is tangled from readme.org
# DO NOT edit by hand
{
  description = "Luca Cambiaghi's darwin configuration";
  inputs = {
    # Package sets
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixpkgs-21.11-darwin;
    nixos-stable.url = github:NixOS/nixpkgs/nixos-21.11;
    
    # Environment/system management
    darwin.url = github:LnL7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
  outputs = inputs@{ self, nixpkgs, darwin, home-manager, flake-utils, ... }:
    let
      nixpkgsConfig = {
        config = { allowUnfree = true; allowUnsupportedSystem = true;};
      };
      homeManagerCommonConfig = {
        imports = with self.homeManagerModules; [
          ./home
          { home.stateVersion = "22.05"; }
          # configs.git.aliases
          # configs.starship.symbols
          # programs.kitty.extras
        ];
      };
      nixDarwinCommonModules = [
        # Main `nix-darwin` config
        ./darwin
        # `home-manager` module
        home-manager.darwinModules.home-manager
        (
          { config, lib, pkgs, ... }:
          let
            primaryUser = "cambiaghiluca";
          in
            {
              nixpkgs = nixpkgsConfig;
              # `home-manager` config
              users.users.${primaryUser}.home = "/Users/${primaryUser}";
              home-manager.useGlobalPkgs = true;
              home-manager.users.${primaryUser} = homeManagerCommonConfig;
            }
        )
      ];
    in {
      darwinConfigurations = rec {
        macbookpro-m1 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              # users.primaryUser = "cambiaghiluca";
              networking = {
                knownNetworkServices = ["Wi-Fi" "Bluetooth PAN" "Thunderbolt Bridge"];
                # hostName =  "luca-macbookpro";
                # computerName = "luca-macbookpro";
                # localHostName = "luca-macbookpro";
              };
            }
          ];
          specialArgs = { inherit inputs nixpkgs; };
        };
      };
      cloudVM = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/luca";
        username = "luca";
        configuration = {
          imports = [ homeManagerCommonConfig ];
          nixpkgs = nixpkgsConfig;
        };
      };
    };
}
