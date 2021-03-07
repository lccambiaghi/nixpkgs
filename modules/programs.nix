{ config, pkgs, ... }:
let
  homeDir = "/Users/luca";
in
{
  imports = [
    ./shells
    ./kitty
  ];

  programs = {
    home-manager = {
      enable = true;
      path = "../home.nix";
    };
    direnv = {
      enable = true;
      # enableFishIntegration = false;
    };
    # emacs = {
    #   enable = true;
    #   package = if pkgs.stdenv.isDarwin then pkgs.emacsGcc else pkgs.emacsPgtkGcc;
    # };
    # firefox = {
    #   enable = true;
    #   # package = pkgs.Firefox; # custom overlay
    #   extensions =
    #     with pkgs.nur.repos.rycee.firefox-addons; [
    #       ublock-origin
    #       # browserpass
    #       vimium
    #     ];
    #   profiles = {
    #     home = {
    #       id = 0;
    #       settings = {
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
    #           # "identity.fxaccounts.account.device.name" = config.networking.hostName;
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
    #       # userChrome = (builtins.readFile (pkgs.substituteAll {
    #       #   name = "homeUserChrome";
    #       #   src = ../conf.d/userChrome.css;
    #       #   tabLineColour = "#2aa198";
    #       # }));
    #     };
    #   };
    # };
    fzf.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Luca Cambiaghi";
      userEmail = "luca.cambiaghi@maersk.com";
      signing = {
        key = "2E5064FE";
        # key = "luca.cambiaghi@me.com";
        signByDefault = true;
      };
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
    };
    gpg.enable = true;
    htop = {
      enable = true;
      showProgramPath = true;
    };
    ssh = {
      enable = true;
      # hashKnownHosts = true;
      # userKnownHostsFile = "${xdg.configHome}/ssh/known_hosts";
      matchBlocks = {
        "dsvm" = {
          hostname = "avocado-ds-vm.germanywestcentral.cloudapp.azure.com";
          port = 443;
          user = "luca";
          # identityFile = "$HOME/.ssh/id_rsa.pub";
        };
      };
    };
    # texlive = {
    #   enable = true;
    #   extraPackages = tpkgs: {
    #     inherit (tpkgs)
    #       # maybe useless with scheme-full
    #       capt-of
    #       catchfile
    #       environ
    #       framed
    #       fvextra
    #       tcolorbox
    #       trimspaces
    #       upquote
    #       xstring
    #       # additional
    #       dvipng
    #       fontspec
    #       minted
    #       wrapfig
    #       xetex
    #       # base
    #       scheme-full
    #       latexmk ;
    #   };
    # };
    vim.enable = true;
    # vscode = {
    #   enable = true;
    #   package = with pkgs; vscodium;
    #   userSettings = {
    #     "workbench.colorTheme" = "GitHub Dark";
    #   };
    #   extensions = with pkgs.vscode-extensions; [
    #     bbenoist.Nix
    #   ];
    # };
  };


}
