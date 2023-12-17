{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./brew.nix
    ./preferences.nix
    ./spacebar.nix
  ];

  #####################
  # Nix configuration #
  #####################

  # nixpkgs.overlays = [
    # inputs.nur.overlay
    # inputs.emacs-overlay.overlay
  # ];

  nix = {
    package = pkgs.nixStable;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.nixStable)
      "experimental-features = nix-command flakes"}
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    settings = {
      max-jobs = 8;
      cores = 8;
      substituters = [
        https://cache.nixos.org
        https://nix-community.cachix.org
        # https://mjlbach.cachix.org
        # https://gccemacs-darwin.cachix.org
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "mjlbach.cachix.org-1:dR0V90mvaPbXuYria5mXvnDtFibKYqYc2gtl9MWSkqI="
        # "gccemacs-darwin.cachix.org-1:E0Q1uCBvxw58kfgoWtlletUjzINF+fEIkWknAKBnPhs="
      ];
    };
    nixPath = [
      "nixpkgs=/etc/${config.environment.etc.nixpkgs.target}"
      "home-manager=/etc/${config.environment.etc.home-manager.target}"
      "darwin=/etc/${config.environment.etc.darwin.target}"
    ];
  };

  ########################
  # System configuration #
  ########################

  # Fonts
  fonts = {
    fontDir.enable = true;
    # fonts declared with home-manager
  };

  networking = {
    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  # time.timeZone = "Europe/Paris";

  services.nix-daemon.enable = true;
  # Recreate /run/current-system symlink after boot
  # services.activate-system.enable = true;
  # services.gpg-agent.enable = true;
  # services.keybase.enable = true;
  # services.lorri.enable = true;

  ################
  # environment #
  ################

  environment = {
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${inputs.nixpkgs}";
      darwin.source = "${inputs.darwin}";
    };
    extraInit = ''
      # install homebrew
      command -v brew > /dev/null || ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    '';
    # loginShell = pkgs.fish;
    pathsToLink = [ "/Applications" ];
    shells = [ pkgs.fish pkgs.zsh ];
    # systemPackages = [ ];
    systemPath = [
      # "/run/current-system/sw/bin/" # TODO how to avoid hardcoding?
      "$HOME/.npm-packages/bin"
      "$HOME/.poetry/bin"
      "$HOME/.modular/pkg/packages.modular.com_mojo/bin"
      # "$HOME/.emacs.d/bin"
      # "$HOME/git/doom-emacs/bin"
      # "/opt/homebrew/bin"
      # "/usr/local/homebrew/bin"
      # TODO: /usr/local/bin
      # "$HOME/bin"
    ];
    variables = {
      EDITOR = "emacsclient";
      KUBE_EDITOR="emacsclient";
      LC_ALL="en_US.UTF-8";
      # CLOJURE_LOAD_PATH="$HOME/git/clojure-clr/bin/4.0/Release/"; # NOTE this needs to be present and compiled
      EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs";
      SHELL = "${pkgs.zsh}/bin/zsh";
      LIBRARY_PATH="$(brew --prefix)/lib";
      CPATH="$(brew --prefix)/include";
      CFLAGS="-I$(brew --prefix openssl)/include";
      LDFLAGS="-L$(brew --prefix openssl)/lib";
      MODULAR_HOME="$HOME/.modular";
      # OPENSSL_ROOT_DIR="/opt/homebrew/Cellar/openssl@3/3.0.7/";
      # BROWSER = "firefox";
      # OPENTYPEFONTS="$HOME/.nix-profile/share/fonts/opentype//:";
    };

  };

  programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.bash.enable = true;

  programs.nix-index.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
