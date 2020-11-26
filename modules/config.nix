{ config, lib, pkgs, ... }:

let
  homeDir = builtins.getEnv("HOME");
  user_name = "luca";
  user_full_name = "Luca Cambiaghi";
  user_shell = "zsh";
  user_description = "Luca Cambiaghi";
  user_brew_formulae = [
    "kubectx"
    "libvterm"
    "mas"
    "parquet-tools"
    # "R"
  ];
  user_brew_casks = [
    # "altserver"
    # "amethyst"
    # "1password"
    # "iina"
    # "discord"
    # "docker"
    # "dropbox"
    # "google-chrome"
    # "keybase" # maybe enable in home-manager
    # "menumeters"
    # "microsoft-azure-storage-explorer"
    # "microsoft-office"
    # "microsoft-teams"
    # "private-internet-access"
    # "pycharm-ce"
    # "qbitorrent"
    # "slack"
  ];

in with pkgs.stdenv; with lib; {
  nix.package = pkgs.nix;
  nix.trustedUsers = [ "root" "luca" ];

  environment.shells = [ pkgs.zsh ];
  # environment.systemPackages = [ pkgs.zsh pkgs.gcc ];
  environment.darwinConfig = "${homeDir}/.config/nixpkgs/darwin-configuration.nix";

  home-manager.users.luca = import ./home.nix;

  homebrew = {
    enable = true;
    formulae = user_brew_formulae;
    cask_args.appdir = "/Users/${user_name}/Applications";
    casks = user_brew_casks;
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

  programs.nix-index.enable = true;

  system.activationScripts.postActivation.text = ''
    # Enable HiDPI display modes (requires restart)
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

    # Stop iTunes from responding to the keyboard media keys
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2>/dev/null

    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Show the ~/Library folder
    chflags nohidden ~/Library

    # Hot corners
    # Possible values:
    #  0: no-op
    #  2: Mission Control
    #  3: Show application windows
    #  4: Desktop
    #  5: Start screen saver
    #  6: Disable screen saver
    #  7: Dashboard
    # 10: Put display to sleep
    # Top right screen corner → Display to sleep
    defaults write com.apple.dock wvous-tr-corner -int 10
    defaults write com.apple.dock wvous-tr-modifier -int 0
    # Top left screen corner → Start screen saver
    defaults write com.apple.dock wvous-tl-corner -int 5
    defaults write com.apple.dock wvous-tl-modifier -int 0
  '';

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = false;
      expose-group-by-app = true;
      tilesize            = 36;
      orientation = "left";
    };

    loginwindow = {
      GuestEnabled         = false;
      DisableConsoleAccess = true;
    };

    screencapture.location = "${homeDir}/Desktop";

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    LaunchServices.LSQuarantine = false;


    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick      = true;
    };

    NSGlobalDomain = {
      # "com.apple.trackpad.scaling"         = "3.0";
      AppleFontSmoothing = 1;
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits                = "Centimeters";
      AppleMetricUnits                     = 1;
      AppleShowScrollBars                  = "Automatic";
      AppleShowAllExtensions = true;
      AppleTemperatureUnit                 = "Celsius";
      # InitialKeyRepeat                     = 15;
      KeyRepeat                            = 2;
      NSAutomaticCapitalizationEnabled     = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      _HIHideMenuBar                       = true;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      # Enable full keyboard access for all controls
      # (e.g. enable Tab in modal dialogs)
    };

    alf = {
      globalstate                = 1;
      allowsignedenabled         = 1;
      allowdownloadsignedenabled = 1;
      stealthenabled             = 1;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

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
