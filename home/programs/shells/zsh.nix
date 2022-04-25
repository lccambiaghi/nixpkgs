{ config, lib, pkgs, ... }:
{
  programs.zsh = {
    # inherit shellAliases;
    enable = true;
    # enableAutosuggestions = true;
    # enableCompletion = true;
    # history.extended = true;
    # enableSyntaxHighlighting = true;
    # enableBashCompletion = true;
    # envExtra = ''
    #   # export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
    #   # export PYENV_SHELL="zsh"
    #   # export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
    # '';
    # localVariables = { POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [ "dir" "vcs" ] ; }

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

      if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
        alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
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
