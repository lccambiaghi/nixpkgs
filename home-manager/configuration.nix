{ config, pkgs, ... }:

let
  sources = import ../nix/sources.nix;
  homeDir = builtins.getEnv("HOME");

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
      pip
      pyyaml
      # tabulate
    ];
  };

  # R-with-pkgs = pkgs.rWrapper.override{ packages = with pkgs.rPackages; [
  #   IRkernel
  #   ISLR
  # ]; };

in {
  imports = [
    ./shells.nix
    # ./emacs.nix
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
      "/usr/local/bin"
      # "$HOME/.npm-packages/bin"
    ];

    sessionVariables = {
      EDITOR = "emacsclient";
      KUBE_EDITOR="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
      LIBRARY_PATH="/usr/bin/gcc";
      CLOJURE_LOAD_PATH="$HOME/git/clojure-clr/bin/4.0/Release/"; # NOTE this needs to be present and compiled
      EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs";
      # TERM="xterm";
      TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
      # BROWSER = "firefox";
      # TERMINAL = "alacritty";
    };

    # TODO maybe use xdg.config for all of these?
    file.".config/direnv/direnvrc".source = ../dotfiles/direnvrc;

    file.".clojure/deps.edn".source = ../dotfiles/deps.edn;

    file.".ipython/profile_default/startup/2-pandas.py".source = ../dotfiles/2-pandas.py;

    file.".config/kitty/modus-operandi.conf".source = ../dotfiles/modus-operandi.conf;

    file.".config/kitty/modus-vivendi.conf".source = ../dotfiles/modus-vivendi.conf;

    file.".config/kitty/macos-launch-services-cmdline".text = "--listen-on unix:/tmp/mykitty";

    file.".npmrc".text = "prefix = ${homeDir}/.npm-packages";

    # file.".config/nix/nix.conf".text = ''
    #   substituters = https://cache.nixos.org https://cache.nixos.org/ https://mjlbach.cachix.org
    #   trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= mjlbach.cachix.org-1:dR0V90mvaPbXuYria5mXvnDtFibKYqYc2gtl9MWSkqI=
    # '';

    # file.".emacs.d" = {
    #   source = "$HOME/.emacs.d";
    #   recursive = true;
    # };

    # home.file.".skhdrc".source = ../dotfiles/skhdrc;

  };

  fonts.fontconfig.enable = true;

  news.display = "silent";


  # TODO use programs {} to group them
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
    # package = pkgs.gitAndTools.gitFull;
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
        # editor = "emacsclient";
        # pager = "delta --dark";
        whitespace = "trailing-space,space-before-tab";
        # fileMode = false;
      };

      # commit.gpgsign = "true";
      # gpg.program = "gpg2";

      ui.color = "always";
      github.user = "lccambiaghi";

      protocol.keybase.allow = "always";
      credential.helper = "osxkeychain";
      pull.rebase = "false";
    };

    # signing = {
    #     key = "XXXXXXXXXXXXXXXXXX";
    #     signByDefault = true;
    #   };
  };

  programs.ssh = {
    enable = true;

    # hashKnownHosts = true;
    # userKnownHostsFile = "${xdg.configHome}/ssh/known_hosts";

  };

  # programs.xdg = {
  #   enable = true;

  #   configHome = "${home_directory}/.config";
  #   dataHome   = "${home_directory}/.local/share";
  #   cacheHome  = "${home_directory}/.cache";

  #   configFile."gnupg/gpg-agent.conf".text = ''
  #     enable-ssh-support
  #     default-cache-ttl 86400
  #     max-cache-ttl 86400
  #     pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
  #   '';
  # };

  # programs.starship.enable = true;

  programs.vim.enable = true;

  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs)
        # additional
        # altacv
        capt-of
        catchfile
        dvipng
        framed
        fvextra
        minted
        upquote
        wrapfig
        xstring
        # base
        scheme-medium
        latexmk ;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      font_size = 16;
    };
    extraConfig = ''
      allow_hyperlinks yes
      allow_remote_control yes
      enable_audio_bell no
      tab_bar_style powerline

      enabled_layouts splits

      # open new split (window) with cmd+d retaining the cwd
      map cmd+d new_window_with_cwd
      # new split with default cwd
      map cmd+shift+d new_window
      # switch between next and previous splits
      map cmd+]        next_window
      map cmd+[        previous_window

      # jump to beginning and end of word
      map alt+left send_text all \x1b\x62
      map alt+right send_text all \x1b\x66
      # jump to beginning and end of line
      map cmd+left send_text all \x01
      map cmd+right send_text all \x05
    '';
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

  # TODO move to separate packages.nix file?
  home.packages = with pkgs; [
    # adoptopenjdk-bin # Java
    argo
    azure-cli
    bash # /bin/bash
    bat # cat replacement written in Rust
    cachix
    clojure
    cmake
    # clang
    conftest
    curl # An old classic
    direnv # Per-directory environment variables
    docker # World's #1 container tool
    # docker-machine # Docker daemon for macOS
    #emacsGccDarwin
    exa # ls replacement written in Rust
    fd # find replacement written in Rust
    font-awesome_5
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
    libtool
    # libvterm-neovim
    leiningen
    less
    mdcat # Markdown converter/reader for the CLI
    # mono
    # next
    niv # Nix dependency management
    nixpkgs-fmt
    nodejs # node and npm
    nodePackages.mermaid-cli
    nodePackages.pyright
    nodePackages.prettier
    # nodePackages.vega-lite
    # nodePackages.vega-cli
    # nuget
    pinentry_mac # Necessary for GPG
    # python37Packages.poetry
    customPython
    # pre-commit # Pre-commit CI hook tool
    procs
    protobuf # Protocol Buffers
    # python37 # Have you upgraded yet???
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

}
