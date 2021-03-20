{ ... }:

let
  user_name = "luca";

in
{
  homebrew.enable = true;
  homebrew.autoUpdate = false;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;

  homebrew = {
    brews = [
      "borkdude/brew/babashka"
      "kubectx"
      # "libvterm"
      "libtool" # required for vterm
      "libomp"
      # required for zmq
      "automake"
      "autogen"
      "autoconf"
      "pkg-config"
      "shtool"
      # "mas"
      # "mono"
      # "nuget"
      # "parquet-tools"
      # "crescentrose"/sunshine
    ];
    # extraConfig = ''
    #     cask_args appdir: "~/BrewApplications", require_sha: true
    # '';
    casks = [
      # "authy"
      # "altserver"
      "amethyst"
      "discord"
      "docker"
      "google-chrome"
      "keybase"
      "microsoft-auto-update"
      "microsoft-azure-storage-explorer"
      "microsoft-office"
      "microsoft-teams"
      "pycharm-ce"
      "slack"
      # "1password"
      # "iina"
      # "discord"
      # "docker"
      # "dozer"
      # "dropbox"
      # "google-chrome"
      # "keybase" # maybe enable in home-manager
      # "karabiner-elements"
      # "menumeters"
      # "microsoft-azure-storage-explorer"
      # "microsoft-office"
      # "microsoft-teams"
      # "private-internet-access"
      # "pycharm-ce"
      # "qbitorrent"
      # "slack"
    ];
    taps = [
      "homebrew/cask"
      "borkdude/brew"
      # "homebrew/cask-fonts"
      # "crescentrose/sunshine"
    ];
  };
}
