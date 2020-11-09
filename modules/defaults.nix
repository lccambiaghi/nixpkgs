{ ... }:

{
  system.defaults.NSGlobalDomain = {
    "com.apple.trackpad.scaling"         = "3.0";
    AppleMeasurementUnits                = "Centimeters";
    AppleMetricUnits                     = 1;
    AppleShowScrollBars                  = "Automatic";
    AppleTemperatureUnit                 = "Celsius";
    InitialKeyRepeat                     = 15;
    KeyRepeat                            = 2;
    NSAutomaticCapitalizationEnabled     = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    _HIHideMenuBar                       = true;
  };

  # Firewall
  system.defaults.alf = {
    globalstate                = 1;
    allowsignedenabled         = 1;
    allowdownloadsignedenabled = 1;
    stealthenabled             = 1;
  };

  # Dock and Mission Control
  system.defaults.dock = {
    autohide            = true;
    expose-group-by-app = false;
    mru-spaces          = false;
    tilesize            = 128;
  };

  # Login and lock screen
  system.defaults.loginwindow = {
    GuestEnabled         = false;
    DisableConsoleAccess = true;
  };

  # Spaces
  # system.defaults.spaces.spans-displays = false;

  # Trackpad
  system.defaults.trackpad = {
    Clicking                = true;
    TrackpadRightClick      = true;
  };

  # Finder
  # system.defaults.finder = {
  #   FXEnableExtensionChangeWarning       = true;
  # };
}
