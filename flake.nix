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
    
    # Other sources
    emacs.url = "github:nix-community/emacs-overlay";
    fish-done = { url = "github:franciscolourenco/done"; flake = false; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  # outputs = { self, darwin, home-manager, flake-utils, ... }@inputs:
  outputs = inputs@{ self, nixpkgs, darwin, home-manager, flake-utils, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;
      nixpkgsConfig = {
        config = { allowUnfree = true; allowUnsupportedSystem = true;};
        overlays = attrValues self.overlays ++ singleton (
          # Sub in x86 version of packages that don't build on Apple Silicon yet
          final: prev: (optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
            inherit (final.pkgs-x86)
              idris2
              nix-index
              niv;
          })
        );
      };
      homeManagerCommonConfig = {
        imports = attrValues self.homeManagerModules ++ [
          ./home
          { home.stateVersion = "22.05"; }
          # configs.git.aliases
          # configs.starship.symbols
          # programs.kitty.extras
        ];
      };
      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        # Main `nix-darwin` config
        ./darwin
        # `home-manager` module
        home-manager.darwinModules.home-manager
        (
          { config, lib, pkgs, ... }:
          let
            inherit (config.users) primaryUser;
          in
            {
              nixpkgs = nixpkgsConfig;
              # Hack to support legacy worklows that use `<nixpkgs>` etc.
              # nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
              # `home-manager` config
              users.users.${primaryUser}.home = "/Users/${primaryUser}";
              home-manager.useGlobalPkgs = true;
              home-manager.users.${primaryUser} = homeManagerCommonConfig;
            }
        )
      ];
    in {
      darwinConfigurations = rec {
        # Mininal configurations to bootstrap systems
        bootstrap-x86 = makeOverridable darwinSystem {
          system = "x86_64-darwin";
          modules = [ ./darwin/bootstrap.nix { nixpkgs = nixpkgsConfig; } ];
        };
        bootstrap-arm = bootstrap-x86.override { system = "aarch64-darwin"; };
        # main macbook configuration
        macbookpro = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = "cambiaghiluca";
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
        # My new Apple Silicon macOS laptop config
        macbookpro-m1 = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules ++ [
            {
              users.primaryUser = "cambiaghiluca";
              networking = {
                knownNetworkServices = ["Wi-Fi" "Bluetooth PAN" "Thunderbolt Bridge"];
                # hostName =  "luca-macbookpro";
                # computerName = "luca-macbookpro";
                # localHostName = "luca-macbookpro";
              };
            }
          ];
        };
        githubCI = darwin.lib.darwinSystem {
          modules = nixDarwinCommonModules { user = "runner"; } ++ [
            ({ lib, ... }: { homebrew.enable = lib.mkForce false; })
          ];
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
      # homeManagerModules = {
      #   configs.git.aliases = import ./home/configs/git-aliases.nix;
      #   configs.gh.aliases = import ./home/configs/gh-aliases.nix;
      #   configs.starship.symbols = import ./home/configs/starship-symbols.nix;
      #   programs.neovim.extras = import ./home/modules/programs/neovim/extras.nix;
      #   programs.kitty.extras = import ./home/modules/programs/kitty/extras.nix;
      # };
      overlays = {
        # Overlays to add different versions `nixpkgs` into package set
        pkgs-master = final: prev: {
          pkgs-master = import inputs.nixpkgs-master {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-stable = final: prev: {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        pkgs-unstable = final: prev: {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit (prev.stdenv) system;
            inherit (nixpkgsConfig) config;
          };
        };
        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages system is running Apple Silicon
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };
      };
    } //
    flake-utils.lib.eachDefaultSystem (system: {
      legacyPackages = import inputs.nixpkgs-unstable {
        inherit system;
        inherit (nixpkgsConfig) config;
        overlays = with self.overlays; [
          pkgs-master
          pkgs-stable
          apple-silicon
        ];
      };
    });
}
