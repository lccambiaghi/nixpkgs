{ config, pkgs, ... }:

let
  # nigpkgsRev = "nixpkgs-unstable";
  # pkgs = import (fetchTarball "https://github.com/nixos/nixpkgs/archive/${nigpkgsRev}.tar.gz") {};

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

  pythonPackages = with pkgs.python38Packages; [
    bpython
    openapi-spec-validator
    pip
    requests
    setuptools
];

in {
  inherit imports;

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  programs.home-manager.enable = true;

  home = {
    username = "luca";
    homeDirectory = "/Users/luca";
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

  programs.direnv.enable = true;

  # programs.poetry.enable = true

  programs.ssh.enable = true;

  programs.vim.enable = true;

  # services.gpg-agent.enable = true;

  # services.keybase.enable = true;

  # GUI apps (home-manager currently has issues adding them to ~/Applications)
  # environment.systemPackages = with pkgs; [
  #   kitty
  # ];
  # programs.nix-index.enable = true;

  # Fonts
  # fonts.fontconfig.enable = true;
  # fonts.enableFontDir = true;
  # fonts.fonts = with pkgs; [
  #   recursive
  #   jetbrains-mono
  #   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # ];

  # Keyboard
  # system.keyboard.enableKeyMapping      = true;
  # system.keyboard.remapCapsLockToEscape = true;

  # Lorri daemon
  # services.lorri.enable = true;

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

  # programs.fish = lib.attrsets.recursiveUpdate (import ../../program/shell/fish/default.nix) {
  #   shellInit = ''
  #     bass source $HOME/.nix-profile/etc/profile.d/nix.sh
  #     direnv hook fish | source
  #     set PATH (fd --absolute-path . $HOME/.config/scripts | tr '\n' ':' | sed 's/.$//') $PATH
  #   '';
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
    adoptopenjdk-bin # Java
    bash # /bin/bash
    bat # cat replacement written in Rust
    conftest
    curl # An old classic
    direnv # Per-directory environment variables
    docker # World's #1 container tool
    docker-machine # Docker daemon for macOS
    exa # ls replacement written in Rust
    fd # find replacement written in Rust
    fzf # Fuzzy finder
    graphviz # dot
    gnupg # gpg
    htop # Resource monitoring
    httpie # Like curl but more user friendly
    jq # JSON parsing for the CLI
    just # Intriguing new make replacement
    kind # Easy Kubernetes installation
    kubectl # Kubernetes CLI tool
    kubectx # kubectl context switching
    kustomize
    lorri # Easy Nix shell
    less
    mdcat # Markdown converter/reader for the CLI
    niv # Nix dependency management
    nodejs # node and npm
    pinentry_mac # Necessary for GPG
    # poetry
    pre-commit # Pre-commit CI hook tool
    protobuf # Protocol Buffers
    python3 # Have you upgraded yet???
    ripgrep # grep replacement written in Rust
    spotify-tui # Spotify interface for the CLI
    tree # Should be included in macOS but it's not
    vscode # My fav text editor if I'm being honest
    wget
    xsv # CSV file parsing utility
    yarn # Node.js package manager
    youtube-dl # Download videos
  ] ++ pythonPackages ++ scripts;

}
