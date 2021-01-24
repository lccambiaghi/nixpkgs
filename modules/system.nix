{ inputs, config, lib, pkgs, ... }:

let
  homePrefix = "/Users";
  homeDir = "/Users/luca";
  defaultUser = "luca";
  userShell = "fish";

in with pkgs.stdenv; with lib; {
  #####################
  # Nix configuration #
  #####################

  nixpkgs.config = import ../config.nix;
  nixpkgs.overlays = [
    inputs.nur.overlay
    # inputs.emacs-overlay.overlay
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes"}
    '';
    trustedUsers = [ "${defaultUser}" "root" "@admin" "@wheel" ];
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
    ];
    binaryCaches = [
      https://cache.nixos.org
      # https://mjlbach.cachix.org
      # https://gccemacs-darwin.cachix.org
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # "mjlbach.cachix.org-1:dR0V90mvaPbXuYria5mXvnDtFibKYqYc2gtl9MWSkqI="
      # "gccemacs-darwin.cachix.org-1:E0Q1uCBvxw58kfgoWtlletUjzINF+fEIkWknAKBnPhs="
    ];
  };

  ################
  # environment #
  ################

  environment = {
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${inputs.nixpkgs}";
    };
    # list of acceptable shells in /etc/shells
    shells = [ pkgs.fish pkgs.zsh ];
  };

  users.users = {
    "${defaultUser}" = {
      description = "Luca Cambiaghi";
      home = "${homePrefix}/${defaultUser}";
      shell = pkgs.${userShell};
      # isHidden = false;
      # createHome = false;
    };
  };

  ################
  # home-manager #
  ################

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${defaultUser} = { inputs, pkgs, ... }: { imports = [ ../home.nix ]; };
  };

  ########################
  # System configuration #
  ########################

  # Fonts
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      jetbrains-mono
      iosevka
      fira-code
      cantarell-fonts
      # (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };

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
}
