{ config, pkgs, ... }:
let
  homeDir = "/Users/luca";
in
{
  imports = [
    ./shells
    ./kitty
  ];

  fonts.fontconfig.enable = true;

  news.display = "silent";

  programs = {
    home-manager = {
      enable = true;
      path = "../home.nix";
    };
    direnv = {
      enable = true;
      enableFishIntegration = false;
    };
    #   firefox.enable = true;
    #   # programs.firefox.package = pkgs.Firefox; # custom overlay
    #   # programs.firefox.extensions =
    #   #   with pkgs.nur.repos.rycee.firefox-addons; [
    #   #     ublock-origin
    #   #     browserpass
    #   #     vimium
    #   #   ];
    fzf.enable = true;
    git = {
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
        signing = {
          # key = "0F79B4782E5064FE";
          key = "luca.cambiaghi@me.com";
          signByDefault = true;
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
    texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs)
          # maybe useless with scheme-full
          capt-of
          catchfile
          environ
          framed
          fvextra
          tcolorbox
          trimspaces
          upquote
          xstring
          # additional
          dvipng
          fontspec
          minted
          wrapfig
          xetex
          # base
          scheme-full
          latexmk ;
      };
    };
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

  xdg = {
    enable = true;
    configHome = "${homeDir}/.config";
    dataHome   = "${homeDir}/.local/share";
    cacheHome  = "${homeDir}/.cache";
    # configFile."gnupg/gpg-agent.conf".text = ''
    #   enable-ssh-support
    #   default-cache-ttl 86400
    #   max-cache-ttl 86400
    #   pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    # '';
  };

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

}
