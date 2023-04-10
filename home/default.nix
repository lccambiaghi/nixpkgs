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

in
{
  imports = [
    ./dotfiles
    ./programs
    # ./python
    ./clojure
    # ./R
  ];

  fonts.fontconfig.enable = true;

  news.display = "silent";

  home = {
    #stateVersion = "20.09";
    packages = with pkgs; [
      # argo
      # automake
      # autoconf
      # azure-cli
      bash # /bin/bash
      bat # cat replacement written in Rust
      # cachix
      # cantarell-fonts
      # cocoapods
      cmake
      # conftest
      # curl
      # docker # World's #1 container tool
      # emacs-all-the-icons-fonts
      exa # ls replacement written in Rust
      fd # find replacement written in Rust
      # font-awesome
      fira-code
      # gitAndTools.gh
      # gitAndTools.git-crypt
      # gnupg # gpg
      # kubectl # Kubernetes CLI tool
      # kubectx # kubectl context switching
      # lorri # Easy Nix shell
      # mosh
      # niv # Nix dependency management
      # nixpkgs-fmt
      nodejs # node and npm
      nodePackages.pyright
      # nodePackages.prettier
      # pandoc
      # pinentry_mac # Necessary for GPG
      poetry
      pre-commit # Pre-commit CI hook tool
      # stable.procs
      # protobuf # Protocol Buffers
      # roboto
      # roboto-mono
      ripgrep # grep replacement written in Rust
      # rsync
      # rustup
      # source-code-pro
      # sqlite
      # tree # Should be included in macOS but it's not
      tree-sitter
      # tmux
      # watch
      wget
      yarn # Node.js package manager
      # youtube-dl # Download videos
    ] ++ scripts;
  };
}
