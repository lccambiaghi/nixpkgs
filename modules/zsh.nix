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
    pj= "python $HOME/bin/pretty_json.py";
    hms = "home-manager switch";

    # Reload zsh
    szsh = "source ~/.zshrc";

    # Reload home manager and zsh
    reload = "cd ~/.config/nixpkgs && ./switch.sh && cd - && source ~/.zshrc";

    # Nix garbage collection
    garbage = "nix-collect-garbage -d && docker image prune --force";

    # See which Nix packages are installed
    installed = "nix-env --query --installed";
  };
in {
  # fish shell settings
  # programs.fish = {
  #   inherit shellAliases;
  #   enable = true;
  # };

  # programs.bash = {
  #   enable = true;
  # };

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
      # export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
      # export PYENV_SHELL="zsh"
      # export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
    '';
    # localVariables = { POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [ "dir" "vcs" ] ; }

    # Called whenever zsh is initialized
    initExtra = ''
      export TERM="xterm-256color"

      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

      bindkey -e

      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Nix setup (environment variables, etc.)
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi

      eval $(thefuck --alias)

      # Load environment variables from a file; this approach allows me to not
      # commit secrets like API keys to Git
      # if [ -e ~/.env ]; then
      #   . ~/.env
      # fi

      # Autocomplete for various utilities
      # source <(kubectl completion zsh)
      # source <(gh completion --shell zsh)

      # pyenv
      # if [ -n "$(which pyenv)" ]; then
      #   eval "$(pyenv init -)"
      # fi

      # Start up Docker daemon if not running
      # if [ $(docker-machine status default) != "Running" ]; then
      #   docker-machine start default
      # fi

      if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
        export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
        alias emacs="$EMACS -nw"
      fi

      if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
        alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
      fi

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
      #     name = "z";
      #     file = "zsh-z.plugin.zsh";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "agkozak";
      #       repo = "zsh-z";
      #       rev = "41439755cf06f35e8bee8dffe04f728384905077";
      #       sha256 = "1dzxbcif9q5m5zx3gvrhrfmkxspzf7b81k837gdb93c4aasgh6x6";
      #     };
      # }
      # {
      #   name = "powerlevel10k-config";
      #   src = lib.cleanSource ./p10k-config;
      #   file = "p10k.zsh";
      # }
    ];

  };
}
