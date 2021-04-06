{ config, lib, pkgs, ... }:
let
  # Handly shell command to view the dependency tree of Nix packages
  depends = pkgs.writeScriptBin "depends" ''
    dep=$1
    nix-store --query --requisites $(which $dep)
  '';

  run = pkgs.writeScriptBin "run" ''
    nix-shell --pure --run "$@"
  '';

  # Collect garbage, optimize store, repair paths
  nix-cleanup-store = pkgs.writeShellScriptBin "nix-cleanup-store" ''
    nix-collect-garbage -d
    nix optimise-store 2>&1 | sed -E 's/.*'\'''(\/nix\/store\/[^\/]*).*'\'''/\1/g' | uniq | sudo -E ${pkgs.parallel}/bin/parallel 'nix-store --repair-path {}'
  '';

  # Symlink macOS apps installed via Nix into ~/Applications
  nix-symlink-apps-macos = pkgs.writeShellScriptBin "nix-symlink-apps-macos" ''
    for app in $(find ~/Applications -name '*.app')
    do
      if test -L $app && [[ $(readlink -f $app) == /nix/store/* ]]; then
        rm $app
      fi
    done
    for app in $(find ~/.nix-profile/Applications/ -name '*.app' -exec readlink -f '{}' \;)
    do
      ln -s $app ~/Applications/$(basename $app)
    done
  '';

  # Update Homebrew pagkages/apps
  brew-bundle-update = pkgs.writeShellScriptBin "brew-bundle-update" ''
    brew update
    brew bundle --file=~/.config/nixpkgs/Brewfile
  '';

  # Remove Homebrew pakages/apps not in Brewfile
  brew-bundle-cleanup = pkgs.writeShellScriptBin "brew-bundle-cleanup" ''
    brew bundle cleanup --zap --force --file=~/.config/nixpkgs/Brewfile
  '';

  # change kitty themes
  lightk = pkgs.writeShellScriptBin "lightk" ''
    kitty @ set-colors -a -c "$HOME/.config/kitty/modus-operandi.conf"
  '';

  darkk = pkgs.writeShellScriptBin "darkk" ''
    kitty @ set-colors -a -c "$HOME/.config/kitty/modus-vivendi.conf"
  '';

  scripts = [
    depends
    run
    nix-cleanup-store
    nix-symlink-apps-macos
    brew-bundle-update
    brew-bundle-cleanup
    lightk
    darkk
  ];

  customPython = pkgs.python37.buildEnv.override {
    extraLibs = with pkgs.python37Packages; [
      black
      # debugpy
      flake8
      ipython
      isort
      # jupyter
      pip
      pyyaml
      # tabulate
    ];
  };

  # R-with-pkgs = pkgs.rWrapper.override{ packages = with pkgs.rPackages; [
  #   IRkernel
  #   ISLR
  # ]; };

in
{
  imports = [ ./programs.nix ./dotfiles ./kitty];

  fonts.fontconfig.enable = true;

  news.display = "silent";

  home = {
    # only need these if not managed by nix-darwin
    # username = "luca";
    # homeDirectory = "/Users/luca";
    stateVersion = "20.09";
    packages = with pkgs; [
      adoptopenjdk-bin # Java
      argo
      azure-cli
      bash # /bin/bash
      bat # cat replacement written in Rust
      cachix
      cantarell-fonts
      # calibre
      clojure
      stable.clojure-lsp
      cmake
      # clang
      conftest
      curl # An old classic
      direnv # Per-directory environment variables
      docker # World's #1 container tool
      # docker-machine # Docker daemon for macOS
      emacs-all-the-icons-fonts
      exa # ls replacement written in Rust
      fd # find replacement written in Rust
      # font-awesome_5
      font-awesome_4
      fira-code
      fzf # Fuzzy finder
      # gcc
      git-lfs
      gitAndTools.gh
      gitAndTools.git-crypt
      graphviz # dot
      gnupg # gpg
      # gtk3
      httpie # Like curl but more user friendly
      jansson
      # jetbrains.pycharm-community
      jq # JSON parsing for the CLI
      just # Intriguing new make replacement
      # libgccjit
      kind # Easy Kubernetes installation
      kubectl # Kubernetes CLI tool
      # kubectx # kubectl context switching
      kustomize
      lorri # Easy Nix shell
      # libtool
      # libvterm-neovim
      leiningen
      less
      # mdcat # Markdown converter/reader for the CLI
      # mono
      niv # Nix dependency management
      nixpkgs-fmt
      nodejs # node and npm
      # nodePackages.mermaid-cli # TODO
      nodePackages.pyright
      nodePackages.prettier
      # nodePackages.vega-lite
      # nodePackages.vega-cli
      # nuget
      # nyxt
      pandoc
      pinentry_mac # Necessary for GPG
      python37Packages.poetry
      customPython
      # pre-commit # Pre-commit CI hook tool
      stable.procs
      protobuf # Protocol Buffers
      # R-with-pkgs
      roboto
      roboto-mono
      ripgrep # grep replacement written in Rust
      rsync
      spotify-tui # Spotify interface for the CLI
      sqlite
      # texlive
      # texlive.combined.scheme-medium
      # imagemagick
      # thefuck
      tectonic
      tree # Should be included in macOS but it's not
      tmux
      vscode # My fav text editor if I'm being honest
      watch
      # webkitgtk
      wget
      xsv # CSV file parsing utility
      yarn # Node.js package manager
      youtube-dl # Download videos
      # zsh-powerlevel10k
    ] ++ scripts;
  };
}
