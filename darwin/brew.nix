{ config, ... }:

{
  # environment.shellInit = ''
  #   eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  # '';

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
      # "mas"
      # "libomp"
      "enchant" # spellchecker
      "pkgconfig"
      # "macosrec" # macosrec --record emacs --gif (ctrl-c in terminal to stop)
      "modular"
      # "openblas"
      # "ollama"
      "openssl"
      # "openssl@1.1"
      "pandoc"
      # "pgvector"
      # "pyenv"
      "python@3.11"
      # "qemu"
      # "msodbcsql17"
      # "mssql-tools"
      "ruff"
      "tree-sitter"
      # "unixodbc"
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
      "alt-tab"
      "1password"
      # "1password6"
      "amethyst"
      "arc"
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
      "macfuse"
      # "microsoft-auto-update"
      # "microsoft-azure-storage-explorer"
      # "microsoft-office"
      "microsoft-teams"
      "postman"
      # "pycharm-ce"
      "pycharm"
      # "raycast"
      # "slack"
      "spotify"
      "stats"
      "iina"
      # "discord"
      # "docker"
      # "dozer"
      # "dropbox"
      "private-internet-access"
      "telegram"
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
      "modularml/packages"
      # "jimeh/emacs-builds"
      # "borkdude/brew"
      # "railwaycat/emacsmacport"
    ];
    extraConfig = ''
        brew "d12frosted/homebrew-emacs-plus/emacs-plus@29", args: ["with-xwidgets", "with-native-comp", "with-no-frame-refocus"]
        # TODO: brew86 install python@3.11 unixodbc
    '';
    # cask_args appdir: "~/Applications", require_sha: true
  };
}
