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
      # "borkdude/brew/babashka"
      # "kubectx"
      # "libvterm"
      # "libtool" # required for vterm
      # "libomp"
      # required for zmq
      # "automake"
      # "autogen"
      # "autoconf"
      # "pkg-config"
      # "shtool"
      # "mas"
      # "mono"
      # "nuget"
      # "parquet-tools"
      # "crescentrose"/sunshine
      "unixodbc"
      ##### cross compilation 
      # "ldid"
      # "docbook-xsl"
      # "po4a"
      # "gnu-sed"
      # "ncurses"
    ];
    casks = [
      # "authy"
      # "altserver"
      "amethyst"
      # "discord"
      "docker"
      "firefox"
      # "google-chrome"
      # "keybase"
      # "microsoft-auto-update"
      # "microsoft-azure-storage-explorer"
      # "microsoft-office"
      # "microsoft-teams"
      # "pycharm-ce"
      # "slack"
      # "1password"
      # "iina"
      # "discord"
      # "docker"
      # "dozer"
      # "dropbox"
      # "menumeters"
      # "microsoft-azure-storage-explorer"
      # "private-internet-access"
    ];
    taps = [
      "homebrew/cask"
      "d12frosted/emacs-plus"
      # "borkdude/brew"
      # "railwaycat/emacsmacport"
    ];
    # extraConfig = ''
    #     cask_args appdir: "~/Applications", require_sha: true
    #     brew "d12frosted/homebrew-emacs-plus/emacs-plus@28", args: ["with-xwidgets", "with-native-comp" "with-no-title-bar"]
    # '';
  };
}
