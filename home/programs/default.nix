{ config, pkgs, ... }:
{
  imports = [
    # ./kitty
    ./latex
    ./shells
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
    #   # package = if pkgs.stdenv.isDarwin then pkgs.emacsGcc else pkgs.emacsPgtkGcc;
    #   package = if pkgs.stdenv.isDarwin then pkgs.emacsMacport else pkgs.emacsPgtkGcc;
    # };
    fzf.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Luca Cambiaghi";
      userEmail = "luca.cambiaghi@me.com";
      # userEmail = "luca.cambiaghi@maersk.com";
      # signing = {
      #   key = "2E5064FE";
      #   # key = "luca.cambiaghi@me.com";
      #   signByDefault = true;
      # };
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
        co = "checkout";
        d = "diff";
        s = "status";
        pr = "pull --rebase";
        st = "status";
        l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
      };
      # Global Git config
      extraConfig = {
        core = {
          whitespace = "trailing-space,space-before-tab";
        };
        # commit.gpgsign = "true";
        # gpg.program = "gpg2";
        ui.color = "always";
        github.user = "lccambiaghi";
        protocol.keybase.allow = "always";
        credential.helper = "osxkeychain";
        pull.rebase = "true";
      };
    };
    # gpg.enable = true;  # gpgconf --kill gpg-agent to restart agent
    htop = {
      enable = true;
    };
    # java = {
    #   enable = true;
    # };
    ssh = {
      enable = true;
      extraConfig = ''
Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519

Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/bcgemu

Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519_prod
      '';
      # hashKnownHosts = true;
      # userKnownHostsFile = "${xdg.configHome}/ssh/known_hosts";
      matchBlocks = {
        "w3vm" = {
          hostname = "104.155.108.203";
          # port = 443;
          user = "cambiaghi.luca";
          # identityFile = "$HOME/.ssh/id_rsa.pub";
        };
        "prodw3vm" = {
          hostname = "104.155.108.203";
          user = "prod";
        };
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

}
