{ config, pkgs, ... }:

let
  # nigpkgsRev = "nixpkgs-unstable";
  # pkgs = import (fetchTarball "https://github.com/nixos/nixpkgs/archive/${nigpkgsRev}.tar.gz") {};
  sources = import ../nix/sources.nix;

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
  imports = [
    ./zsh.nix
  ];

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "20.09";

    sessionPath = [
      "$HOME/.poetry/bin"
      "$HOME/.emacs.d/bin"
      "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin:$PATH"
    ];

    sessionVariables = {
      EDITOR = "emacsclient";
      # BROWSER = "firefox";
      # TERMINAL = "alacritty";
    };

    file.".config/direnv/direnvrc".source = ../dotfiles/direnvrc;

    file.".clojure/deps.edn".source = ../dotfiles/deps.edn;

    # home.file.".skhdrc".source = ../dotfiles/skhdrc;

    # ".tmux.conf" = {
    #  text = ''
    #  set-option -g default-shell /run/current-system/sw/bin/fish
    #  set-window-option -g mode-keys vi
    #  '';
    # };

  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  programs.home-manager.enable = true;

  programs.htop = {
    enable = true;
    showProgramPath = true;
  };

  programs.direnv = {
      enable = true;
      # enableNixDirenvIntegration = true;
  };

  programs.fzf.enable = true;

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    lfs.enable = true;
    userName = "Luca Cambiaghi";
    userEmail = "luca.cambiaghi@maersk.com";

    # Replaces ~/.gitignore
    ignores = [
      ".cache/"
      ".DS_Store"
      ".idea/"
      "*.swp"
      "built-in-stubs.jar"
      "dumb.rdb"
      ".elixir_ls/"
      ".vscode/"
      "npm-debug.log"
      "shell.nix"
    ];

    # Replaces aliases in ~/.gitconfig
    aliases = {
      ba = "branch -a";
      bd = "branch -D";
      br = "branch";
      cam = "commit -am";
      co = "checkout";
      cob = "checkout -b";
      ci = "commit";
      cm = "commit -m";
      cp = "commit -p";
      d = "diff";
      dco = "commit -S --amend";
      s = "status";
      pr = "pull --rebase";
      st = "status";
      l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
      whoops = "reset --hard";
      wipe = "commit -s";
      fix = "rebase --exec 'git commit --amend --no-edit -S' -i origin/develop";
    };

    # Global Git config
    extraConfig = {
      core = {
        editor = "emacsclient";
        # pager = "delta --dark";
        whitespace = "trailing-space,space-before-tab";
      };

      # commit.gpgsign = "true";
      # gpg.program = "gpg2";

      protocol.keybase.allow = "always";
      credential.helper = "osxkeychain";
      pull.rebase = "false";
    };
  };

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

  # programs.vscode = {
  #   enable = true;

  #   package = with pkgs; vscodium;

  #   userSettings = {
  #     "workbench.colorTheme" = "GitHub Dark";
  #   };

  #   extensions = with pkgs.vscode-extensions; [
  #     bbenoist.Nix
  #   ];
  # };

  #   programs.firefox.enable = true;
  #   # programs.firefox.package = pkgs.Firefox; # custom overlay
  #   # programs.firefox.extensions =
  #   #   with pkgs.nur.repos.rycee.firefox-addons; [
  #   #     ublock-origin
  #   #     browserpass
  #   #     vimium
  #   #   ];

  #   programs.firefox.profiles =
  #     let defaultSettings = {
  #           "app.update.auto" = false;
  #           # "browser.startup.homepage" = "https://lobste.rs";
  #           # "browser.search.region" = "GB";
  #           # "browser.search.countryCode" = "GB";
  #           "browser.search.isUS" = false;
  #           "browser.ctrlTab.recentlyUsedOrder" = false;
  #           "browser.newtabpage.enabled" = false;
  #           "browser.bookmarks.showMobileBookmarks" = true;
  #           "browser.uidensity" = 1;
  #           "browser.urlbar.placeholderName" = "DuckDuckGo";
  #           "browser.urlbar.update1" = true;
  #           "distribution.searchplugins.defaultLocale" = "en-GB";
  #           "general.useragent.locale" = "en-GB";
  #           "identity.fxaccounts.account.device.name" = config.networking.hostName;
  #           "privacy.trackingprotection.enabled" = true;
  #           "privacy.trackingprotection.socialtracking.enabled" = true;
  #           "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
  #           "reader.color_scheme" = "sepia";
  #           "services.sync.declinedEngines" = "addons,passwords,prefs";
  #           "services.sync.engine.addons" = false;
  #           "services.sync.engineStatusChanged.addons" = true;
  #           "services.sync.engine.passwords" = false;
  #           "services.sync.engine.prefs" = false;
  #           "services.sync.engineStatusChanged.prefs" = true;
  #           "signon.rememberSignons" = false;
  #           "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  #         };
  #     in {
  #       home = {
  #         id = 0;
  #         settings = defaultSettings;
  #         userChrome = (builtins.readFile (pkgs.substituteAll {
  #           name = "homeUserChrome";
  #           src = ../conf.d/userChrome.css;
  #           tabLineColour = "#2aa198";
  #         }));
  #       };

  #       work = {
  #         id = 1;
  #         settings = defaultSettings // {
  #           "browser.startup.homepage" = "about:blank";
  #           "browser.urlbar.placeholderName" = "Google";
  #         };
  #         userChrome = (builtins.readFile (pkgs.substituteAll {
  #           name = "workUserChrome";
  #           src = ../conf.d/userChrome.css;
  #           tabLineColour = "#cb4b16";
  #         }));
  #       };
  #     };

  #   # programs.emacs.enable = true;
  #   # programs.emacs.package = pkgs.emacsMacport;

  # Fonts
  # fonts.fontconfig.enable = true;
  # fonts.enableFontDir = true;
  # fonts.fonts = with pkgs; [
  #   recursive
  #   jetbrains-mono
  #   (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  # ];

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
    docker # World's #1 container tool
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
