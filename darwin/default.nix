{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./brew.nix
    ./preferences.nix
  ];

  #####################
  # Nix configuration #
  #####################

  # nixpkgs.overlays = [
    # inputs.nur.overlay
    # inputs.emacs-overlay.overlay
  # ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes"}
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    buildCores = 8;
    maxJobs = 8;
    readOnlyStore = true;
    nixPath = [
      "nixpkgs=/etc/${config.environment.etc.nixpkgs.target}"
      "home-manager=/etc/${config.environment.etc.home-manager.target}"
      "darwin=/etc/${config.environment.etc.darwin.target}"
    ];
    binaryCaches = [
      https://cache.nixos.org
      https://nix-community.cachix.org
      # https://mjlbach.cachix.org
      # https://gccemacs-darwin.cachix.org
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "mjlbach.cachix.org-1:dR0V90mvaPbXuYria5mXvnDtFibKYqYc2gtl9MWSkqI="
      # "gccemacs-darwin.cachix.org-1:E0Q1uCBvxw58kfgoWtlletUjzINF+fEIkWknAKBnPhs="
    ];
  };

  ########################
  # System configuration #
  ########################

  # Fonts
  fonts = {
    enableFontDir = true;
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

  services.spacebar.enable = true;
  services.spacebar.package = pkgs.spacebar;
  services.spacebar.config = {
    debug_output       = "on";
    # position           = "bottom";
    position           = "top";
    clock_format       = "%R";
    space_icon_strip   = "    ";
    text_font          = ''"Menlo:Bold:12.0"'';
    icon_font          = ''"FontAwesome:Regular:12.0"'';
    background_color   = "0xff202020";
    foreground_color   = "0xffa8a8a8";
    space_icon_color   = "0xff14b1ab";
    dnd_icon_color     = "0xfffcf7bb";
    clock_icon_color   = "0xff99d8d0";
    power_icon_color   = "0xfff69e7b";
    battery_icon_color = "0xffffbcbc";
    power_icon_strip   = " ";
    space_icon         = "";
    clock_icon         = "";
    dnd_icon           = "";
  };

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
      command -v brew > /dev/null || ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    '';
    # loginShell = pkgs.fish;
    pathsToLink = [ "/Applications" ];
    shells = [ pkgs.fish pkgs.zsh ];
    # systemPackages = [ ];
    systemPath = [
      "/run/current-system/sw/bin/" # TODO how to avoid hardcoding?
      "$HOME/.poetry/bin"
      # "$HOME/.emacs.d/bin"
      "$HOME/git/doom-emacs/bin"
    ];
    variables = {
      EDITOR = "emacsclient";
      KUBE_EDITOR="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
      LC_ALL="en_US.UTF-8";
      LIBRARY_PATH="/usr/bin/gcc";
      CLOJURE_LOAD_PATH="$HOME/git/clojure-clr/bin/4.0/Release/"; # NOTE this needs to be present and compiled
      EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs";
      SHELL = "${pkgs.zsh}/bin/zsh";
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
