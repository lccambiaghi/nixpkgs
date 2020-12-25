{ config, lib, pkgs, ... }:

let
  # Set all shell aliases programatically
  shellAliases = {
    # Aliases for commonly used tools
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
    kgj= "kubectl get jobs";
    kdl= "kubectl delete ";
    kds= "kubectl describe ";
    pj= "python $HOME/bin/pretty_json.py";
    hms = "home-manager switch";
    cljclr="mono $CLOJURE_LOAD_PATH/Clojure.Main.exe";

    # Reload zsh
    szsh = "source ~/.zshrc";

    # Reload home manager and zsh
    reload = "cd ~/.config/nixpkgs && ./switch.sh && cd - && source ~/.config/fish/config.fish";

    # Nix garbage collection
    garbage = "nix-collect-garbage -d && docker image prune --all --force";

    # See which Nix packages are installed
    installed = "nix-env --query --installed";

    # emacs
    emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
    em="emacsclient -n ";
  };
in {
  # echo "$HOME/.nix-profile/bin/fish" | sudo tee -a /etc/shells
  # sudo chsh -s "$HOME/.nix-profile/bin/fish" "$USER"
  programs.fish = {
    enable = true;
    inherit shellAliases;
    shellInit = ''
      direnv hook fish | source
      direnv export fish | source
    '';
    loginShellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end

      # automatically change kitty colors based on time of day
      if test -n "$KITTY_WINDOW_ID"
        if test (date "+%H") -le 15 # TODO how to sync with Emacs?
            lightk
            set -u BAT_THEME ansi-light
        else
            darkk
        end
      end

      # apparently kitty needs a special ssh command
      if test "$TERM" = "xterm-kitty"
        alias ssh="kitty +kitten ssh"
      end

      # if status --is-interactive
      #     set PATH $PATH ~/.npm-packages/bin;
      # end

      # erase with set --erase --universal fish_user_paths if you screw up
      # fish_user_paths /usr/local/bin $fish_user_paths

      # switch (sunshine -s "@55 12")
      #   case 'day'
      #      lightk
      #   case 'night'
      #     darkk
      # end
      '';

    functions = {
     fish_greeting = "";

     vterm_printf = ''
        if [ -n "$TMUX" ]
            # tell tmux to pass the escape sequences through
            # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
            printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
        else if string match -q -- "screen*" "$TERM"
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$argv"
        else
            printf "\e]%s\e\\" "$argv"
        end
      '';

     # direnv_hook = ''
     #    set -q direnv_eval_on_pwd or set -g direnv_eval_on_pwd true

     #    function __direnv_export_eval --on-event fish_prompt
     #      # Run on each prompt to update the state
     #      command direnv export fish | source

     #      # Handle cd history arrows between now and the next prompt
     #      function __direnv_cd_hook --on-variable PWD
     #        $direnv_eval_on_pwd
     #        and command direnv export fish | source
     #        or set -g __direnv_export_again 0
     #      end
     #    end

     #    function __direnv_disable_cd_hook --on-event fish_preexec;
     #      if set -q __direnv_export_again
     #        set -e __direnv_export_again
     #        command direnv export fish | source
     #        echo
     #      end

     #      # Once we're running commands, stop monitoring cd changes
     #      # until we get to the prompt again
     #      functions --erase __direnv_cd_hook
     #    end
     # '';


     # __switch_them = {
     #   body = "__fish_default_command_not_found_handler $argv[1]";
     #   onevent = "fish_command_not_found";
     # };

    };

    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "50eba266b0d8a952c7230fca1114cbc9fbbdfbd4";
          sha256 = "0ppmajynpb9l58xbrcnbp41b66g7p0c9l2nlsvyjwk6d16g4p4gy";
        };
      }

      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
          # sha256 = lib.fakeSha256
        };
      }
    ];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      character.success_symbol = "[~>](bold green)"; # "[λ](bold green)";
      character.error_symbol= "[~>](bold red)";
      scan_timeout = 10;
      # kubernetes.disabled = false;
      package.disabled = true;
      # python.format = "via [🐍 ( \($virtualenv\))]($style) ";
      python.disabled = true;
    };
  };

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
