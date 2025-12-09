{ config, pkgs, ... }:
{
  imports = [
    # ./kitty
    # ./latex
    ./shells
  ];

  programs = {

    direnv = {
      enable = true;
      # enableFishIntegration = false;
    };

    # emacs = {
    #   enable = true;
    #   # package = if pkgs.stdenv.isDarwin then pkgs.emacsGcc else pkgs.emacsPgtkGcc;
    #   package = if pkgs.stdenv.isDarwin then pkgs.emacsMacport else pkgs.emacsPgtkGcc;
    # };

    dircolors.enable = true;

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
      # Replaces ~/config/git/ignore
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
        ".direnv/*"
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
Host github.com-Cambiaghi-Luca_bcgprod
  HostName github.com
  User git
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519

Host github.com-lccambiaghi
  HostName github.com
  User git
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519_personal

Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa_cyber
      '';
      # hashKnownHosts = true;
      # userKnownHostsFile = "${xdg.configHome}/ssh/known_hosts";
      matchBlocks = {
        "c2" = {
          hostname = "34.34.112.30";
          user = "cambiaghiluca";
        };
        "c4" = {
          hostname = "34.133.216.214 ";
          user = "cambiaghiluca";
        };
      };
    };
    vim.enable = true;
    vscode = {
      enable = true;
      # package = with pkgs; vscodium;
      # userSettings = {
      #   "workbench.colorTheme" = "GitHub Dark";
      # };
      # extensions = with pkgs.vscode-extensions; [
      #   bbenoist.Nix
      # ];
    };
  };

}
