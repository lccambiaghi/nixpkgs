{ config, ... }:

let
  user_name = "luca";


  # /Users/cambiaghiluca/git/ran_optimization/.direnv/python-3.9.16/bin/python
  # cd ~/Downloads && mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew && sudo mv homebrew /usr/local/homebrew


in
{
  environment.shellInit = ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  homebrew = {
    enable = true;
    # onActivation.autoUpdate = false;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    # homebrew.global.noLock = true;

    brews = [
      # required for zmq
      "automake"
      "autogen"
      "autoconf"
      # "mas"
      # "libomp"
      # "openblas"
      "openssl"
      "openssl@1.1"
      # "pyenv"
      # "python@3.10"
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
      "dozer"
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
        brew "d12frosted/homebrew-emacs-plus/emacs-plus@29", args: ["with-xwidgets", "with-native-comp"]
    '';
    # cask_args appdir: "~/Applications", require_sha: true
  };
}
