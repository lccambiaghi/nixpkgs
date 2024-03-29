{ config, lib, pkgs, ... }:

let
  inherit (import ./aliases.nix { pkgs = pkgs; }) shellAliases;
in

{
  programs.zsh = {
    inherit shellAliases;
    enable = true;
    # enableAutosuggestions = true;
    # enableCompletion = true;
    # history.extended = true;
    # enableSyntaxHighlighting = true;
    # enableBashCompletion = true;

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

    oh-my-zsh = {
      enable = false;
      plugins = [
        "git"
        "common-aliases"
     ];
    };

  };
}
