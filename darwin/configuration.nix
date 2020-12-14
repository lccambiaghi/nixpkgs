{ config, lib, pkgs, ... }:

let
  homeDir = builtins.getEnv("HOME");
  user_name = "luca";
  user_full_name = "Luca Cambiaghi";
  user_description = "Luca Cambiaghi";

in with pkgs.stdenv; with lib; {

  #######################
  # Modules and Imports #
  #######################

  imports = [
    # Personal modules
    ./modules/homebrew-bundle.nix

    # import home-manager from niv
    "${(import <home-manager> {}).path}/nix-darwin"

    # Other nix-darwin configurations
    ./brew.nix
    ./defaults.nix
  ]; # ++ lib.filter lib.pathExists [ ./private.nix ];

  #####################
  # Nix configuration #
  #####################

  # nix.nixPath = [
  #   { nixpkgs = "$HOME/.nix-defexpr/channels/nixpkgs"; }
  # ];
  # nix.binaryCaches = [
  #   "https://cache.nixos.org/"
  #   "https://iohk.cachix.org"
  #   "https://hydra.iohk.io"
  #   "https://malo.cachix.org"
  # ];
  # nix.binaryCachePublicKeys = [
  #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #   "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
  #   "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  #   "malo.cachix.org-1:fJL4+lpyMs/1cdZ23nPQXArGj8AS7x9U67O8rMkkMIo="
  # ];

  nixpkgs.config = import ../config.nix;

  # TODO overlays to root
  # nixpkgs.overlays = [ (import ./emacs-darwin.nix) ];

  # nixpkgs.overlays = [ (import ../overlays) ];
  # nixpkgs.config.packageOverrides = pkgs: {
  #   nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #     inherit pkgs;
  #   };
  # };

  # nixpkgs.overlays = [ emacs-overlay ];


  nix.package = pkgs.nix;
  nix.trustedUsers = [ "root" "luca" "@admin"];

  # TODO
  # nix.nixPath = [
  #   "darwin-config=$HOME/src/nix/config/darwin.nix"
  #   "home-manager=$HOME/src/nix/home-manager"
  #   "darwin=$HOME/src/nix/darwin"
  #   "nixpkgs=$HOME/src/nix/nixpkgs"
  #   "ssh-config-file=$HOME/.ssh/config"
  #   "ssh-auth-sock=${xdg_configHome}/gnupg/S.gpg-agent.ssh"
  # ];

  environment.shells = [ "${homeDir}/.nix-profile/bin/fish" ]; # NOTE you need to chsh -s .nix-profile/bin/fish
  environment.darwinConfig = "${homeDir}/.config/nixpkgs/darwin/configuration.nix";

  # TODO maybe after having extracted it? What are the benefits?
  # environment.systemPackages = import ./packages.nix { inherit pkgs; }

  # environment.systemPath = [
  #   "$HOME/.poetry/bin"
  #   "$HOME/.emacs.d/bin"
  #   "/run/current-system/sw/bin"
  #   "$HOME/.nix-profile/bin:$PATH"
  #   "/usr/local/bin"
  #   # "$HOME/.npm-packages/bin"
  # ];

  # environment.variables = {
  #   EDITOR = "emacsclient";
  #   KUBE_EDITOR="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
  #   LIBRARY_PATH="/usr/bin/gcc";
  #   CLOJURE_LOAD_PATH="$HOME/git/clojure-clr/bin/4.0/Release/"; # NOTE this needs to be present and compiled
  #   EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs";
  #   # TERM="xterm";
  #   TERM = "xterm-256color";
  #   TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  #   # BROWSER = "firefox";
  #   # TERMINAL = "alacritty";
  # };

  programs.nix-index.enable = true;

  ################
  # home-manager #
  ################

  home-manager.users.luca = import ../home-manager/configuration.nix;

  ########################
  # System configuration #
  ########################

  # Fonts
  # fonts.enableFontDir = true;
  # fonts.fonts = with pkgs; [
  #   recursive
  #   jetbrains-mono
  #   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # ];

  networking = {
    knownNetworkServices = ["Wi-Fi" "Bluetooth PAN" "Thunderbolt Bridge"];
    hostName =  "luca-macbookpro";
    computerName = "luca-macbookpro";
    localHostName = "luca-macbookpro";
    # dns = [
    #   "1.1.1.1"
    #   "8.8.8.8"
    # ];
  };

  # time.timeZone = "Europe/Paris";

  system.stateVersion = 4;

  services.nix-daemon.enable = true;
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
    space_icon_strip   = "    ";
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

  users.users.${user_name} = {
    description = "${user_description}";
    home = "${homeDir}";
    shell = "${homeDir}/.nix-profile/bin/fish";
  };

}
