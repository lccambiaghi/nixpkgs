{ config, lib, pkgs, ... }:

{
  home.file.".config/direnv/direnvrc".source = ../dotfiles/direnvrc;

  home.file.".clojure/deps.edn".source = ../dotfiles/deps.edn;

  # home.file.".skhdrc".source = ../dotfiles/skhdrc;

  # ".tmux.conf" = {
  #  text = ''
  #  set-option -g default-shell /run/current-system/sw/bin/fish
  #  set-window-option -g mode-keys vi
  #  '';
  # };

}
