{ config, lib, pkgs, ... }:

let
  inherit (import ./aliases.nix { pkgs = pkgs; }) shellAliases;
in

{
  programs.zsh = {
    inherit shellAliases;
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
    };

    # Called whenever zsh is initialized
    initExtra = ''
      export TERM="xterm-256color"

      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

      bindkey -e

      # Nix setup (environment variables, etc.)
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi

      if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
        export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
        alias emacs="$EMACS -nw"
      fi

      [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/zsh"

      if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';

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
      # golang.disabled = true;
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
