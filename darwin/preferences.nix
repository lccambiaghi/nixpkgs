{ ... }:

let
  homeDir = "/Users/luca";

in {

  system.activationScripts.postActivation.text = ''
    # Stop iTunes from responding to the keyboard media keys
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2>/dev/null

    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # show dock on both displays
    defaults write com.apple.Dock appswitcher-all-displays -bool true

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

    screencapture.location = "${homeDir}/Desktop";

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick      = true;
    };

    NSGlobalDomain = {
      AppleFontSmoothing = 1;
      ApplePressAndHoldEnabled = true;
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
      # auto hide menu bar on top
      _HIHideMenuBar                       = false;
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

}
