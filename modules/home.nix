{ config, pkgs, ... }:

let
  # nigpkgsRev = "nixpkgs-unstable";
  # pkgs = import (fetchTarball "https://github.com/nixos/nixpkgs/archive/${nigpkgsRev}.tar.gz") {};
  sources = import ./nix/sources.nix;

  # Import other Nix files
  imports = [
    ./git.nix
    ./zsh.nix
    # ./vscode.nix
  ];

  # Handly shell command to view the dependency tree of Nix packages
  depends = pkgs.writeScriptBin "depends" ''
    dep=$1
    nix-store --query --requisites $(which $dep)
  '';

  run = pkgs.writeScriptBin "run" ''
    nix-shell --pure --run "$@"
  '';

  scripts = [
    depends
    run
  ];

  pythonPackages = with pkgs.python37Packages; [
    pip
  ];

  rPackages = with pkgs.rPackages; [
    IRkernel
    ISLR
  ];

  # R-with-pkgs = pkgs.rWrapper.override{ packages = with pkgs.rPackages; [
  #   IRkernel
  #   ISLR
  # ]; };

in {
  inherit imports;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  programs.home-manager.enable = true;

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "20.09";
  };

  # Networking
  # networking.dns = [
  #   "1.1.1.1"
  #   "8.8.8.8"
  # ];
  # networking.computerName = "Luca’s 💻";
  # networking.hostName     = "LucaMacbookPor";
  # networking.knownNetworkServices = [
  #   "Wi-Fi"
  #   "USB 10/100/1000 LAN"
  # ];

  programs.htop = {
    enable = true;
    showProgramPath = true;
  };

  programs.direnv = {
      enable = true;
      # enableNixDirenvIntegration = true;
  };

  programs.fzf.enable = true;

  programs.ssh.enable = true;

  programs.vim.enable = true;

  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs)
        scheme-medium
        dvipng
        latexmk ;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_size = 16;
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
    };
  };

  # services.gpg-agent.enable = true;

  # services.keybase.enable = true;

  # Fonts
  # fonts.fontconfig.enable = true;
  # fonts.enableFontDir = true;
  # fonts.fonts = with pkgs; [
  #   recursive
  #   jetbrains-mono
  #   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # ];

  home.sessionPath = [
    "$HOME/.poetry/bin"
    "$HOME/.emacs.d/bin"
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin:$PATH"
  ];

  home.sessionVariables = {
    EDITOR = "emacsclient";
    # BROWSER = "firefox";
    # TERMINAL = "alacritty";
  };


    # programs.alacritty = {
  #   enable = true;
  #   settings = lib.attrsets.recursiveUpdate (import ../../program/terminal/alacritty/default-settings.nix) {
  #     shell.program = "/usr/local/bin/fish";
  #   };
  # };

  # spacemacs
  # ".emacs.d" = {
  #    source = fetchFromGitHub {
  #      owner = "syl20bnr";
  #      repo = "spacemacs";
  #      rev = "1f93c05";
  #      sha256 = "1x0s5xlwhajgnlnb9mk0mnabhvhsf97xk05x79rdcxwmf041h3fd";
  #    };
  #    recursive = true;
  # };
  # ".spacemacs".source = substituteAll ( (import ./spacemacs-substitutions.nix { inherit lib; })
  #                                       // { src =./spacemacs; });


  home.packages = with pkgs; [
    # adoptopenjdk-bin # Java
    azure-cli
    bash # /bin/bash
    bat # cat replacement written in Rust
    clojure
    # clang
    conftest
    curl # An old classic
    direnv # Per-directory environment variables
    # docker # World's #1 container tool
    # docker-machine # Docker daemon for macOS
    exa # ls replacement written in Rust
    fd # find replacement written in Rust
    font-awesome_5
    fzf # Fuzzy finder
    git-lfs
    gitAndTools.gh
    gitAndTools.git-crypt
    graphviz # dot
    gnupg # gpg
    # htop # Resource monitoring
    httpie # Like curl but more user friendly
    # jetbrains.pycharm-community
    jq # JSON parsing for the CLI
    just # Intriguing new make replacement
    kind # Easy Kubernetes installation
    kubectl # Kubernetes CLI tool
    kubectx # kubectl context switching
    kustomize
    lorri # Easy Nix shell
    less
    mdcat # Markdown converter/reader for the CLI
    # next
    niv # Nix dependency management
    nixpkgs-fmt
    nodejs # node and npm
    nodePackages.pyright
    pinentry_mac # Necessary for GPG
    # python37Packages.poetry
    pre-commit # Pre-commit CI hook tool
    procs
    protobuf # Protocol Buffers
    python37 # Have you upgraded yet???
    # R
    # R-with-pkgs
    ripgrep # grep replacement written in Rust
    rsync
    spotify-tui # Spotify interface for the CLI
    # texlive
    # texlive.combined.scheme-medium
    # imagemagick
    thefuck
    tree # Should be included in macOS but it's not
    tmux
    vscode # My fav text editor if I'm being honest
    watch
    wget
    xsv # CSV file parsing utility
    yarn # Node.js package manager
    youtube-dl # Download videos
    # zsh-powerlevel10k
  ] ++ pythonPackages ++ scripts;

}
