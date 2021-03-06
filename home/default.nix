{ config, lib, pkgs, ... }:
let
  # Symlink macOS apps installed via Nix into ~/Applications
  nix-symlink-apps-macos = pkgs.writeShellScriptBin "nix-symlink-apps-macos" ''
    for app in $(find ~/Applications -name '*.app')
    do
      if test -L $app && [[ $(greadlink -f $app) == /nix/store/* ]]; then
        rm $app
      fi
    done
    for app in $(find ~/.nix-profile/Applications/ -name '*.app' -exec greadlink -f '{}' \;)
    do
      echo "symlinking $(basename $app) into ~/Applications"
      ln -s $app ~/Applications/$(basename $app)
    done
  '';
  scripts = [
    nix-symlink-apps-macos
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
    stateVersion = "20.09";
    packages = with pkgs; [
      adoptopenjdk-bin # Java
      argo
      azure-cli
      bash # /bin/bash
      bat # cat replacement written in Rust
      cachix
      cantarell-fonts
      clojure
      cocoapods
      stable.clojure-lsp
      cmake
      # clang
      conftest
      curl
      docker # World's #1 container tool
      # docker-machine # Docker daemon for macOS
      emacs-all-the-icons-fonts
      exa # ls replacement written in Rust
      fd # find replacement written in Rust
      # font-awesome_5
      font-awesome_4
      fira-code
      gitAndTools.gh
      gitAndTools.git-crypt
      gnupg # gpg
      kubectl # Kubernetes CLI tool
      # kubectx # kubectl context switching
      # lorri # Easy Nix shell
      mosh
      niv # Nix dependency management
      nixpkgs-fmt
      nodejs # node and npm
      # nodePackages.mermaid-cli # TODO
      nodePackages.pyright
      nodePackages.prettier
      # nodePackages.vega-lite
      # nodePackages.vega-cli
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
      sqlite
      tectonic  # latex 
      tree # Should be included in macOS but it's not
      tmux
      watch
      # webkitgtk
      wget
      yarn # Node.js package manager
      youtube-dl # Download videos
    ] ++ scripts;
  };
}
