{
  description = "Luca Cambiaghi's darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:rycee/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # inputs.emacs-overlay = {
    #   type = "github";
    #   owner = "mjlbach";
    #   repo = "emacs-overlay";
    #   ref = "feature/flakes";
    # };
  };


  outputs = { self, ... }@inputs:
    let
      # overlays = [
      #   inputs.emacs-overlay.overlay
      # ];
      configuration = { pkgs, ... }: {
        # xdg.configFile."nix/nix.conf".source = ./configs/nix/nix.conf; # TODO
        # nixpkgs.overlays = overlays;
        nix.package = pkgs.nixFlakes;
        nixpkgs.config = import ./config.nix; # necessary for allowUnfree=true
        environment.shells = [ "/Users/luca/.nix-profile/bin/fish" ]; # still need to chsh -s .nix-profile/bin/fish
        programs.nix-index.enable = true;
        # home-manager.users.luca = import ./home-manager/configuration.nix;
        system.stateVersion = 4;
        services.nix-daemon.enable = true;
      };
    in
    {
    darwinConfigurations."luca-macbookpro" = inputs.darwin.lib.darwinSystem {
      modules = [
        configuration
        (import ./darwin/defaults.nix)
        # ./modules/homebrew-bundle.nix
        # ./brew.nix
        # ./defaults.nix
      ];
    };

    # darwinConfigurations."simple" = darwin.lib.darwinSystem {
    #   modules = [ darwin.darwinModules.simple ];
    # };
  };
}
