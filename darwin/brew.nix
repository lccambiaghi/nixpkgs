{ config, ... }:

{
  environment.shellInit = ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  homebrew = {
    enable = true;
    onActivation.autoUpdate = false;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    # homebrew.global.noLock = true;

    brews = [
      # required for zmq
      "automake"
      "autogen"
      "autoconf"
      "gcc"
      # required by krell (cljs RN)
      # "cocoapods"

      # "mas"
      # "libomp"
      "enchant"
      "pkgconfig"
      "macosrec" # macosrec --record emacs --gif (ctrl-c in terminal to stop)
      # "openblas"
      "openssl"
      "openssl@1.1"
      "pandoc"
      # "pyenv"
      # "python@3.10"
      "qemu"
      # "msodbcsql17"
      # "mssql-tools"
      "ruff"
      "tree-sitter"
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
      "dozer"
      "gifox"
      # "microsoft-edge"
      # "emacs-app-good"
      "firefox"
      "font-sf-mono-nerd-font"
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
      "epk/epk"
      "xenodium/macosrec"
      # "jimeh/emacs-builds"
      # "borkdude/brew"
      # "railwaycat/emacsmacport"
    ];
    extraConfig = ''
        brew "d12frosted/homebrew-emacs-plus/emacs-plus@29", args: ["with-xwidgets", "with-native-comp", "with-no-frame-refocus"]
    '';
    # cask_args appdir: "~/Applications", require_sha: true
  };
}
