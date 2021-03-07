{
  description = "Luca Cambiaghi's darwin configuration";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-20.09";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Other sources
    fish-done = { url = "github:franciscolourenco/done"; flake = false; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, flake-utils, ... }:
    let
      # Some building blocks --------------------------------------------------------------------- {{{
      # Configuration for `nixpkgs` mostly used in personal configs.
      nixpkgsConfig = with inputs; {
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
        overlays = [
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
      homeManagerCommonConfig = with self.homeManagerModules; {
        imports = [
          ./home.nix
          # configs.git.aliases
          # configs.starship.symbols
          # programs.kitty.extras
        ];
      };

      # Modules shared by most `nix-darwin` personal configurations.
      nixDarwinCommonModules = { user }: [
        # Main `nix-darwin` config
        ./darwin-configuration.nix
        # `home-manager` module
        home-manager.darwinModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          # Hack to support legacy worklows that use `<nixpkgs>` etc.
          # nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
          # `home-manager` config
          users.users.${user}.home = "/Users/${user}";
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = homeManagerCommonConfig;
        }
      ];

    in {
      
      # My macOS main laptop config
      darwinConfigurations."luca-macbookpro" = darwin.lib.darwinSystem {
        modules = nixDarwinCommonModules { user = "luca"; } ++ [
          {
            networking = {
              knownNetworkServices = ["Wi-Fi" "Bluetooth PAN" "Thunderbolt Bridge"];
              hostName =  "luca-macbookpro";
              computerName = "luca-macbookpro";
              localHostName = "luca-macbookpro";
            };
          }
        ];
        specialArgs = { inherit inputs nixpkgs; };
      };

    };
}
