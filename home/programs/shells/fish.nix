{ config, lib, pkgs, ... }:

let
  inherit (import ./aliases.nix { pkgs = pkgs; }) shellAliases;
in

{

  # echo "$HOME/.nix-profile/bin/fish" | sudo tee -a /etc/shells
  # sudo chsh -s "/run/current-system/sw/bin/fish" "$USER"
  programs.fish = {
    enable = true;
    inherit shellAliases;
    shellInit = ''
      direnv hook fish | source
      direnv export fish | source
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
    enableZshIntegration = true;
    settings = {
      character.success_symbol = "[~>](bold green)"; # "[λ](bold green)";
      character.error_symbol= "[~>](bold red)";
      directory.fish_style_pwd_dir_length = 1; # turn on fish directory truncation
      directory.truncation_length = 2; # number of directories not to truncate
      scan_timeout = 10;
      # git_status.format = "";
      git_status.disabled = true;
      kubernetes.format = "on [⛵ $context \($namespace\)](dimmed green) ";
      kubernetes.context_aliases = {
        "core-dev-west-1" = "dev";
      };
      battery.disabled = true;
      buf.disabled = true;
      c.disabled = true;
      cobol.disabled = true;
      conda.disabled = true;
      docker_context.disabled = true;
      dotnet.disabled = true;
      elixir.disabled = true;
      elm.disabled = true;
      erlang.disabled = true;
      fennel.disabled = true;
      gcloud.disabled = true;
      go.disabled = true;
      gradle.disabled = true;
      haskell.disabled = true;
      haxe.disabled = true;
      helm.disabled = true;
      kotlin.disabled = true;
      kubernetes.disabled = true;
      lua.disabled = true;
      meson.disabled = true;
      nim.disabled = true;
      nodejs.disabled = true;
      ocaml.disabled = true;
      perl.disabled = true;
      php.disabled = true;
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
        "$package"
        "$python"
        "$nix_shell"
        "$memory_usage"
        "$custom"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$time"
        "$status"
        "$shell"
        "$character"
      ];
    };
  };


}
