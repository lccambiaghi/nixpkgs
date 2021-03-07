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
    gccemacs-darwin = {
      type = "github";
      owner = "twlz0ne";
      repo = "nix-gccemacs-darwin";
      ref = "master";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    let
      # Some building blocks --------------------------------------------------------------------- {{{
      # Configuration for `nixpkgs` mostly used in personal configs.
      nixpkgsConfig = with inputs; {
        config = { allowUnfree = true; };
        overlays = self.overlays ++ [
          (
            final: prev:
            let
              system = prev.stdenv.system;
              nixpkgs-stable = if system == "x86_64-darwin" then nixpkgs-stable-darwin else nixos-stable;
            in {
              master = nixpkgs-master.legacyPackages.${system};
              stable = nixpkgs-stable.legacyPackages.${system};
            }
          )
        ];
      };

      # Personal configuration shared between `nix-darwin` and plain `home-manager` configs.
      # homeManagerCommonConfig = with self.homeManagerModules; {
      #   imports = [
      #     ./home
      #     configs.git.aliases
      #     configs.gh.aliases
      #     configs.starship.symbols
      #     programs.neovim.extras
      #     programs.kitty.extras
      #   ];
      # };

    in {
      
      # Configuration for `nixpkgs` mostly used in personal configs.
      # My macOS main laptop config
      # MaloBookPro = darwin.lib.darwinSystem {
      #   modules = nixDarwinCommonModules { user = "malo"; } ++ [
      #     {
      #         networking.computerName = "Malo’s 💻";
      #         networking.hostName = "MaloBookPro";
      #         networking.knownNetworkServices = [
      #           "Wi-Fi"
      #           "USB 10/100/1000 LAN"
      #         ];
      #       }
      #     ];
      #   };


    darwinConfigurations."luca-macbookpro" = darwin.lib.darwinSystem {
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
      ];
      specialArgs = { inherit inputs nixpkgs; };
    };

};
}
