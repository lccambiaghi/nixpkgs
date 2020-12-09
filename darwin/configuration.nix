{ config, lib, pkgs, ... }:

let
  homeDir = builtins.getEnv("HOME");
  user_name = "luca";
  user_full_name = "Luca Cambiaghi";
  user_shell = "zsh";
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

  nix.package = pkgs.nix;
  nix.trustedUsers = [ "root" "luca" ];

  environment.shells = [ pkgs.zsh ];
  # environment.systemPackages = [ pkgs.zsh pkgs.gcc ];
  environment.darwinConfig = "${homeDir}/.config/nixpkgs/darwin/configuration.nix";

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

  programs.nix-index.enable = true;

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
    home = "/Users/${user_name}";
    shell = pkgs.${user_shell};
  };

}
