{ pkgs, ... }:

{
  imports = [
    ./dotfiles
    ./programs
    # ./python
    ./clojure
    # ./R
  ];

  # nixpkgs.config.allowUnsupportedSystem = true;

  fonts.fontconfig.enable = true;

  # news.display = "silent";

  home = {
    stateVersion = "24.11";
    packages = with pkgs; [
      # argo
      # automake
      # autoconf
      azure-cli
      bash # /bin/bash
      bat # cat replacement written in Rust
      # cachix
      # cantarell-fonts
      cocoapods
      cmake
      # conftest
      # curl
      dasel
      # docker # World's #1 container tool
      # emacs-all-the-icons-fonts
      # enchant
      eza # ls replacement written in Rust
      fd # find replacement written in Rust
      ffmpeg
      # font-awesome
      fira-code
      google-cloud-sdk
      gh
      # gitAndTools.gh
      # gitAndTools.git-crypt
      # gnupg # gpg
      # ispell
      # kubectl # Kubernetes CLI tool
      # kubectx # kubectl context switching
      # lorri # Easy Nix shell
      # mosh
      # niv # Nix dependency management
      # nixpkgs-fmt
      nodejs # node and npm
      pyright
      nodePackages.eslint
      nodePackages.mermaid-cli
      # nodePackages.prettier
      # ollama
      # pandoc
      # pinentry_mac # Necessary for GPG
      # poetry
      # pre-commit # Pre-commit CI hook tool
      # stable.procs
      # protobuf # Protocol Buffers
      # roboto
      # roboto-mono
      ripgrep # grep replacement written in Rust
      # rsync
      rustup
      shellcheck
      # source-code-pro
      # sqlite
      # terraform
      tree # Should be included in macOS but it's not
      tree-sitter
      # tmux
      # watch
      wget
      yarn # Node.js package manager
      # youtube-dl # Download videos
    ];
  };
}
