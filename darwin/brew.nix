{ ... }:

let
  user_name = "luca";

in
{
  homebrew = {
    enable = true;
    # onActivation.autoUpdate = false;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    # TODO: newer brew for ARM uses "/opt/homebrew/bin"
    brewPrefix = "/usr/local/bin";
    # homebrew.global.noLock = true;

    brews = [
      # "borkdude/brew/babashka"
      # "kubectx"
      # "libvterm"
      # "libtool" # required for vterm
      # "libomp"
      # required for zmq
      "automake"
      "autogen"
      "autoconf"
      # "clojure"
      # "pkg-config"
      # "shtool"
      # "mas"
      # "mono"
      # "nuget"
      # "parquet-tools"
      # "crescentrose"/sunshine
      "libomp"
      "openssl"
      "openssl@1.1"
      "qemu"
      # "msodbcsql17"
      # "mssql-tools"
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
      # "1password"
      # "1password6"
      "amethyst"
      # "dash"
      "docker"
      # "microsoft-edge"
      # "emacs-app-good"
      "firefox"
      # "discord"
      # "google-chrome"
      # "keybase"
      # "microsoft-auto-update"
      # "microsoft-azure-storage-explorer"
      # "microsoft-office"
      "microsoft-teams"
      # "pycharm-ce"
      # "pycharm"
      "raycast"
      # "slack"
      "stats"
      # "iina"
      # "discord"
      # "docker"
      # "dozer"
      # "dropbox"
      # "menumeters"
      # "microsoft-azure-storage-explorer"
      # "private-internet-access"
      # "unity"
      # "zulu" # ARM version of Java
    ];
    taps = [
      "clojure/tools"
      "homebrew/cask"
      "homebrew/cask-versions"
      "d12frosted/emacs-plus"
      "microsoft/mssql-release"
      # "jimeh/emacs-builds"
      # "borkdude/brew"
      # "railwaycat/emacsmacport"
    ];
    extraConfig = ''
        brew "d12frosted/homebrew-emacs-plus/emacs-plus@28", args: ["with-xwidgets", "with-native-comp", "with-no-titlebar"]
    '';
    # cask_args appdir: "~/Applications", require_sha: true
  };
}
