{ config, lib, pkgs, ... }:

let
  # Set all shell aliases programatically
  shellAliases = {
    # Aliases for commonly used tools
    em = "emacsclient -n ";
    grep = "grep --color=auto";
    cat = "bat";
    find = "fd";
    l = "exa";
    ll = "ls -lh";
    ls = "exa";
    k = "kubectl";
    kp = "kubectl get pods";
    kl = "kubectl logs";
    wkp= "watch -n 1 kubectl get pods";
    kpr= "kubectl get pods --field-selector status.phase=Running";
    wkpr= "watch -n 1 kubectl get pods --field-selector status.phase=Running";
    kga= "kubectl get all";
    kdl= "kubectl delete ";
    kds= "kubectl describe ";
    pj= "$HOME/bin/pj";
    hms = "home-manager switch";

    # Reload zsh
    szsh = "source ~/.zshrc";

    # Reload home manager and zsh
    reload = "home-manager switch && source ~/.zshrc";

    # Nix garbage collection
    garbage = "nix-collect-garbage -d && docker image prune --force";

    # See which Nix packages are installed
    installed = "nix-env --query --installed";
  };
in {
  # Fancy filesystem navigator
  # programs.broot = {
  #   enable = true;
  #   enableFishIntegration = true;
  #   enableZshIntegration = true;
  # };

  # fish shell settings
  # programs.fish = {
  #   inherit shellAliases;
  #   enable = true;
  # };

  # programs.bash = {
  #   enable = true;
  # };

  # environment.shells = with pkgs; [
  #    bashInteractive
  #    fish
  #    zsh
  #  ];

  # zsh settings
  programs.zsh = {
    inherit shellAliases;
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.extended = true;
    # enableSyntaxHighlighting = true;
    # enableBashCompletion = true;
    envExtra = ''
      export PATH="$HOME/.pyenv/bin:$PATH"
      export PATH="$HOME/.pyenv/shims:$PATH"
      export PATH="$HOME/.poetry/bin:$PATH"
    '';
    # localVariables = { POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [ "dir" "vcs" ] ; }

    # Called whenever zsh is initialized
    initExtra = ''
      export TERM="xterm-256color"

      bindkey -e

      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Nix setup (environment variables, etc.)
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi

      # Load environment variables from a file; this approach allows me to not
      # commit secrets like API keys to Git
      # if [ -e ~/.env ]; then
      #   . ~/.env
      # fi

      # Autocomplete for various utilities
      source <(kubectl completion zsh)
      # source <(gh completion --shell zsh)

      # pyenv
      # if [ -n "$(which pyenv)" ]; then
      #   eval "$(pyenv init -)"
      # fi

      # direnv setup
      if [ -n "$(which direnv)" ]; then
        eval "$(direnv hook zsh)"
      fi

      # Start up Docker daemon if not running
      # if [ $(docker-machine status default) != "Running" ]; then
      #   docker-machine start default
      # fi

      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "common-aliases"
     ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # src = pkgs.fetchFromGitHub {
        #   owner = "zsh-users";
        #   repo = "zsh-autosuggestions";
        #   rev = "v0.4.0";
        #   sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        # };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.1.0";
          sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
        };
      }

      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "5fab542516579bdea5cc8b94137d9d85a0c3fda5";
          sha256 = "1ff1z2snbl9rx3mrcjbamlvc21fh9l32zi2hh9vcgcwbjwn5kikg";
        };
      }
      # {
      #   name = "powerlevel10k-config";
      #   src = lib.cleanSource ./p10k-config;
      #   file = "p10k.zsh";
      # }
    ];

  };
}
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
