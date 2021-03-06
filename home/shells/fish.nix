{ config, lib, pkgs, ... }:

let
  # Set all shell aliases programatically
  shellAliases = {
    # Aliases for commonly used tools
    grep = "grep --color=auto";
    cat = "bat";

    # first Create Command-line Launcher
    ds="/usr/local/bin/dataspell";

    vmstart="az vm start -g rgpazewpmlit-forecasting-tooling-001 -n avocado-ds-vm";

    find = "fd";

    l = "${pkgs.exa}/bin/exa";
    ls = "${pkgs.exa}/bin/exa";
    la = "${pkgs.exa}/bin/exa -la";
    ll = "${pkgs.exa}/bin/exa -lh";
    lt = "${pkgs.exa}/bin/exa --tree";

    k = "kubectl";
    ke = "kubectl edit";
    kx = "kubectl exec -ti ";
    kp = "kubectl get pods";
    kj = "kubectl get jobs";
    kc = "kubectl get cronjobs";
    kl = "kubectl logs";
    klf = "kubectl logs -f ";
    wkp= "watch -n 1 kubectl get pods";
    kpr= "kubectl get pods --field-selector status.phase=Running";
    wkpr= "watch -n 1 kubectl get pods --field-selector status.phase=Running";
    kga= "kubectl get all";
    kgj= "kubectl get jobs";
    kdl= "kubectl delete ";
    kds= "kubectl describe ";
    pj= "python $HOME/bin/pretty_json.py";

    cljclr="mono $CLOJURE_LOAD_PATH/Clojure.Main.exe";

    pipde = "poetry run pip install debugpy";
    pipdt = "poetry run pip install dtale";

    # Reload home manager and zsh
    reload = "cd ~/git/nixpkgs && darwin-rebuild switch --flake .#luca-macbookpro && cd -";

    # Nix garbage collection
    garbage = "sudo nix-collect-garbage -d && docker image prune --all --force";

    # See which Nix packages are installed with nix-env
    installed = "nix-env --query --installed";

    # emacs
    # emacs="/Applications/Emacs.app/Contents/MacOS/Emacs";
    # emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
    em="emacsclient -a \"\" -n";
  };
in {
  # echo "$HOME/.nix-profile/bin/fish" | sudo tee -a /etc/shells
  # sudo chsh -s "/run/current-system/sw/bin/fish" "$USER"
  programs.fish = {
    enable = true;
    inherit shellAliases;
    shellInit = ''
      direnv hook fish | source
      direnv export fish | source
    '';
    loginShellInit = ''
      # automatically change kitty colors based on time of day
      if test -n "$KITTY_WINDOW_ID"
      # TODO "defaults read -g AppleInterfaceStyle" is better
        if test (date "+%H") -le 18
            lightk
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

     vterm_cmd = ''
        set -l vterm_elisp ()
        for arg in $argv
            set -a vterm_elisp (printf '"%s" ' (string replace -a -r '([\\\\"])' '\\\\\\\\$1' $arg))
        end
        vterm_printf '51;E'(string join ''' $vterm_elisp)
      '';

      find_file = ''
        set -q argv[1]; or set argv[1] "."
        vterm_cmd find-file (realpath "$argv")
      '';
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
      directory.fish_style_pwd_dir_length = 1; # turn on fish directory truncation
      directory.truncation_length = 2; # number of directories not to truncate
      scan_timeout = 10;
      # git_status.format = "";
      git_status.disabled = true;
      kubernetes.disabled = false;
      kubernetes.format = "on [⛵ $context \($namespace\)](dimmed green) ";
      kubernetes.context_aliases = {
        "core-dev-west-1" = "dev";
      };
      package.disabled = true;
      # python.format = "via [🐍 ( \($virtualenv\))]($style) ";
      python.disabled = true;
      nodejs.disabled = true;
      java.disabled = true;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_status"
        "$kubernetes"
        "$hg_branch"
        "$docker_context"
        "$package"
        "$cmake"
        "$python"
        "$nix_shell"
        "$memory_usage"
        "$custom"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$battery"
        "$time"
        "$status"
        "$shell"
        "$character"
      ];
    };
  };


}
