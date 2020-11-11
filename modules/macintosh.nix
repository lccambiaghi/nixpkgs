{ config, lib, pkgs, ... }:

let
  homeDir = builtins.getEnv("HOME");

in with pkgs.stdenv; with lib; {
  # nix.maxJobs = 8;
  # nix.buildCores = 0;
  nix.package = pkgs.nix;
  services.nix-daemon.enable = true;
  # services.lorri.enable = true;

  # nixpkgs.overlays = [ (import ../overlays) ];
  nix.trustedUsers = [ "root" "luca" ];

  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnsupportedSystem = true;

  # nixpkgs.config.packageOverrides = pkgs: {
  #   nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #     inherit pkgs;
  #   };
  # };

  environment.shells = [ pkgs.zsh ];

  programs.nix-index.enable = true;

  # environment.systemPackages = [ pkgs.zsh pkgs.gcc ];

  environment.darwinConfig = "${homeDir}/.config/nixpkgs/configuration.nix";

  # time.timeZone = "Europe/Paris";
  users.users.luca.shell = pkgs.zsh;
  users.users.luca.home = homeDir;

  system.defaults = {
    dock = {
      autohide = false;
      mru-spaces = false;
      minimize-to-application = false;
      expose-group-by-app = true;
      tilesize            = 128;
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

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick      = false;
    };

    NSGlobalDomain = {
      "com.apple.trackpad.scaling"         = "3.0";
      AppleMeasurementUnits                = "Centimeters";
      AppleMetricUnits                     = 1;
      AppleShowScrollBars                  = "Automatic";
      AppleTemperatureUnit                 = "Celsius";
      # InitialKeyRepeat                     = 15;
      # KeyRepeat                            = 2;
      NSAutomaticCapitalizationEnabled     = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      _HIHideMenuBar                       = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Firewall
  system.defaults.alf = {
    globalstate                = 1;
    allowsignedenabled         = 1;
    allowdownloadsignedenabled = 1;
    stealthenabled             = 1;
  };

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

  # services.skhd.enable = true;
  # services.skhd.skhdConfig = (builtins.readFile (pkgs.substituteAll {
  #   name = "homeUserChrome";
  #   src = ../conf.d/skhd.conf;
  #   vt220 = pkgs.writeShellScript "vt220OpenOrSelect" ''
  #     WIN=$(${pkgs.yabai}/bin/yabai -m query --windows | ${pkgs.jq}/bin/jq '[.[]|select(.title=="vt220")]|unique_by(.id)')
  #     if [[ $WIN != '[]' ]]; then
  #       ID=$(echo $WIN | ${pkgs.jq}/bin/jq '.[].id')
  #       FOCUSED=$(echo $WIN | ${pkgs.jq}/bin/jq '.[].focused')
  #       if [[ $FOCUSED == 1 ]]; then
  #         ${pkgs.yabai}/bin/yabai -m window --focus recent || \
  #         ${pkgs.yabai}/bin/yabai -m space --focus recent
  #       else
  #         ${pkgs.yabai}/bin/yabai -m window --focus $ID
  #       fi
  #     else
  #       open -n ~/.nix-profile/Applications/Alacritty.app \
  #       --args --live-config-reload \
  #       --config-file $HOME/.config/alacritty/live.yml \
  #       -t vt220 --dimensions 80 24 --position 10000 10000 \
  #       -e ${pkgs.tmux}/bin/tmux a -t vt
  #     fi
  #   '';
  # }));

  # launchd.daemons.serialconsole = {
  #   command = "/usr/libexec/getty std.ttyUSB cu.usbserial";
  #   serviceConfig = {
  #     Label = "ae.cmacr.vt220";
  #     KeepAlive = true;
  #     EnvironmentVariables = {
  #       PATH = (lib.replaceStrings ["$HOME"] [( builtins.getEnv("HOME") )] config.environment.systemPath);
  #     };
  #   };
  # };

  # services.yabai = {
  #   enable = true;
  #   package = pkgs.yabai;
  #   enableScriptingAddition = true;
  #   config = {
  #     window_border                = "on";
  #     window_border_width          = 4;
  #     active_window_border_color   = "0xff00afaf";
  #     normal_window_border_color   = "0xff505050";
  #     focus_follows_mouse          = "autoraise";
  #     mouse_follows_focus          = "off";
  #     window_placement             = "second_child";
  #     window_opacity               = "off";
  #     window_opacity_duration      = "0.0";
  #     active_window_border_topmost = "off";
  #     window_topmost               = "on";
  #     window_shadow                = "float";
  #     active_window_opacity        = "1.0";
  #     normal_window_opacity        = "1.0";
  #     split_ratio                  = "0.50";
  #     auto_balance                 = "on";
  #     mouse_modifier               = "fn";
  #     mouse_action1                = "move";
  #     mouse_action2                = "resize";
  #     layout                       = "bsp";
  #     top_padding                  = 10;
  #     bottom_padding               = 10;
  #     left_padding                 = 10;
  #     right_padding                = 10;
  #     window_gap                   = 10;
  #     external_bar                 = "all:0:26";
  #   };
  # };

  # launchd.user.agents.spacebar.serviceConfig.StandardErrorPath = "/tmp/spacebar.err.log";
  # launchd.user.agents.spacebar.serviceConfig.StandardOutPath = "/tmp/spacebar.out.log";

  # Recreate /run/current-system symlink after boot
  # services.activate-system.enable = true;

  home-manager.users.luca = import ./home.nix;

  # home-manager.users.luca = {
  #   home.packages = (import ./packages.nix { inherit pkgs; });

  #   home.sessionVariables = {
  #     PAGER = "less -R";
  #     EDITOR = "emacsclient";
  #   };

  #   programs.git.enable = true;
  #   programs.git.lfs.enable = true;
  #   programs.git.userName = mkDefault "luca";
  #   programs.git.userEmail = mkDefault "luca.cambiaghi@me.com";
  #   programs.git.signing.key = mkDefault "0F79B4782E5064FE";
  #   programs.git.signing.signByDefault = mkDefault true;

  #   programs.firefox.enable = true;
  #   # programs.firefox.package = pkgs.Firefox; # custom overlay
  #   # programs.firefox.extensions =
  #   #   with pkgs.nur.repos.rycee.firefox-addons; [
  #   #     ublock-origin
  #   #     browserpass
  #   #     vimium
  #   #   ];

  #   programs.firefox.profiles =
  #     let defaultSettings = {
  #           "app.update.auto" = false;
  #           # "browser.startup.homepage" = "https://lobste.rs";
  #           # "browser.search.region" = "GB";
  #           # "browser.search.countryCode" = "GB";
  #           "browser.search.isUS" = false;
  #           "browser.ctrlTab.recentlyUsedOrder" = false;
  #           "browser.newtabpage.enabled" = false;
  #           "browser.bookmarks.showMobileBookmarks" = true;
  #           "browser.uidensity" = 1;
  #           "browser.urlbar.placeholderName" = "DuckDuckGo";
  #           "browser.urlbar.update1" = true;
  #           "distribution.searchplugins.defaultLocale" = "en-GB";
  #           "general.useragent.locale" = "en-GB";
  #           "identity.fxaccounts.account.device.name" = config.networking.hostName;
  #           "privacy.trackingprotection.enabled" = true;
  #           "privacy.trackingprotection.socialtracking.enabled" = true;
  #           "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
  #           "reader.color_scheme" = "sepia";
  #           "services.sync.declinedEngines" = "addons,passwords,prefs";
  #           "services.sync.engine.addons" = false;
  #           "services.sync.engineStatusChanged.addons" = true;
  #           "services.sync.engine.passwords" = false;
  #           "services.sync.engine.prefs" = false;
  #           "services.sync.engineStatusChanged.prefs" = true;
  #           "signon.rememberSignons" = false;
  #           "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  #         };
  #     in {
  #       home = {
  #         id = 0;
  #         settings = defaultSettings;
  #         userChrome = (builtins.readFile (pkgs.substituteAll {
  #           name = "homeUserChrome";
  #           src = ../conf.d/userChrome.css;
  #           tabLineColour = "#2aa198";
  #         }));
  #       };

  #       work = {
  #         id = 1;
  #         settings = defaultSettings // {
  #           "browser.startup.homepage" = "about:blank";
  #           "browser.urlbar.placeholderName" = "Google";
  #         };
  #         userChrome = (builtins.readFile (pkgs.substituteAll {
  #           name = "workUserChrome";
  #           src = ../conf.d/userChrome.css;
  #           tabLineColour = "#cb4b16";
  #         }));
  #       };
  #     };

  #   # programs.emacs.enable = true;
  #   # programs.emacs.package = pkgs.emacsMacport;

  #   programs.fzf.enable = true;
  #   programs.fzf.enableZshIntegration = true;

  #   # xdg.configFile."alacritty/light.yml".text =
  #   #   let lightColours = {
  #   #         colors = {
  #   #           primary.background = "0xfdf6e3";
  #   #           primary.foreground = "0x586e75";

  #   #           normal = {
  #   #             black = "0x073642";
  #   #             red = "0xdc322f";
  #   #             green = "0x859900";
  #   #             yellow = "0xb58900";
  #   #             blue = "0x268bd2";
  #   #             magenta = "0xd33682";
  #   #             cyan = "0x2aa198";
  #   #             white = "0xeee8d5";
  #   #           };

  #   #           bright = {
  #   #             black = "0x002b36";
  #   #             red = "0xcb4b16";
  #   #             green = "0x586e75";
  #   #             yellow = "0x657b83";
  #   #             blue = "0x839496";
  #   #             magenta = "0x6c71c4";
  #   #             cyan = "0x93a1a1";
  #   #             white = "0xfdf6e3";
  #   #           };
  #   #         };
  #   #       }; in
  #   #     replaceStrings [ "\\\\" ] [ "\\" ]
  #   #       (builtins.toJSON (
  #   #         config.home-manager.users.cmacrae.programs.alacritty.settings
  #   #         // lightColours
  #   #       ));

  #   # programs.alacritty = {
  #   #   enable = true;
  #   #   settings = {
  #   #     window.padding.x = 15;
  #   #     window.padding.y = 15;
  #   #     window.decorations = "buttonless";
  #   #     window.dynamic_title = false;
  #   #     scrolling.history = 100000;
  #   #     live_config_reload = true;
  #   #     selection.save_to_clipboard = true;
  #   #     mouse.hide_when_typing = true;

  #   #     font = {
  #   #       normal.family = "Menlo";
  #   #       size = 12;
  #   #     };

  #   #     colors = {
  #   #       primary.background = "0x282c34";
  #   #       primary.foreground = "0xabb2bf";

  #   #       normal = {
  #   #         black = "0x282c34";
  #   #         red = "0xe06c75";
  #   #         green = "0x98c379";
  #   #         yellow = "0xd19a66";
  #   #         blue = "0x61afef";
  #   #         magenta = "0xc678dd";
  #   #         cyan = "0x56b6c2";
  #   #         white = "0xabb2bf";
  #   #       };

  #   #       bright = {
  #   #         black = "0x5c6370";
  #   #         red = "0xe06c75";
  #   #         green = "0x98c379";
  #   #         yellow = "0xd19a66";
  #   #         blue = "0x61afef";
  #   #         magenta = "0xc678dd";
  #   #         cyan = "0x56b6c2";
  #   #         white = "0xffffff";
  #   #       };
  #   #     };

  #   #     key_bindings = [
  #   #       { key = "V"; mods = "Command"; action = "Paste"; }
  #   #       { key = "C"; mods = "Command"; action = "Copy";  }
  #   #       { key = "Q"; mods = "Command"; action = "Quit";  }
  #   #       { key = "Q"; mods = "Control"; chars = "\\x11"; }
  #   #       { key = "F"; mods = "Alt"; chars = "\\x1bf"; }
  #   #       { key = "B"; mods = "Alt"; chars = "\\x1bb"; }
  #   #       { key = "D"; mods = "Alt"; chars = "\\x1bd"; }
  #   #       { key = "Slash"; mods = "Control"; chars = "\\x1f"; }
  #   #       { key = "Period"; mods = "Alt"; chars = "\\e-\\e."; }
  #   #       { key = "N"; mods = "Command"; command = {
  #   #           program = "open";
  #   #           args = ["-nb" "io.alacritty"];
  #   #         };
  #   #       }
  #   #     ];
  #   #   };
  #   # } ;


  # };
}
