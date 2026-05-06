{ ... }:

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
      # "codex" # openai/tap repo removed
      "databricks"
      "gcc"
      "graphviz"
      # "mas"
      "libomp"
      "llm"
      # "enchant" # spellchecker
      "pkgconfig"
      # "macosrec" # macosrec --record emacs --gif (ctrl-c in terminal to stop)
      # "mermaid-cli"
      "modular"
      # "openblas"
      "openssl"
      # "openssl@1.1"
      "pandoc"
      "poppler"
      # "pgvector"
      # "pyenv"
      "python@3.10"
      "python@3.11"
      # "qemu"
      "qwen-code"
      # "msodbcsql17"
      # "mssql-tools"
      "ruff"
      "spicetify-cli"
      "tree-sitter"
      # "unixodbc"
      "uv"
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
      # "alt-tab"
      "1password"
      # "1password6"
      "amethyst"
      "audacity"
      "brave-browser"
      # "arc"
      "chatgpt"
      "cursor"
      "embyserver"
      # "dash"
      # "copilot-for-xcode"
      "docker"
      "jordanbaird-ice"
      # "git-credential-manager"
      # "gifox"
      # "microsoft-edge"
      # "emacs-app-good"
      # "firefox"
      "font-sf-mono-nerd-font"
      # "discord"
      # "google-chrome"
      # "keybase"
      "libreoffice"
      "lm-studio"
      "logseq"
      "maccy"
      # "macfuse"
      # "microsoft-auto-update"
      # "microsoft-azure-storage-explorer"
      # "microsoft-office"
      "microsoft-teams"
      "nvidia-geforce-now"
      # "ollama"
      "opencode-desktop"
      # "postman"
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
      # "tailscale"
      "telegram"
      # "unity"
      # "zulu" # ARM version of Java
    ];
    taps = [
      "anomalyco/tap"
      "clojure/tools"
      "databricks/tap"
      "d12frosted/emacs-plus"
      "microsoft/mssql-release"
      "epk/epk"
      "xenodium/macosrec"
      "modularml/packages"
      # "openai/tap" # repo no longer exists
      # "jimeh/emacs-builds"
      # "borkdude/brew"
      # "railwaycat/emacsmacport"
    ];
    extraConfig = ''
        brew "d12frosted/homebrew-emacs-plus/emacs-plus@31", args: ["with-xwidgets"]
        # TODO: brew86 install python@3.11 unixodbc
    '';
    # cask_args appdir: "~/Applications", require_sha: true
  };
}
