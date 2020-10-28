{ config, lib, pkgs, ... }:

{
  home.file.".config/direnv/direnvrc".source = ./direnv/direnvrc;

  home.file.".clojure/deps.edn".source = ./clojure/deps.edn;

  # ".tmux.conf" = {
  #  text = ''
  #  set-option -g default-shell /run/current-system/sw/bin/fish
  #  set-window-option -g mode-keys vi
  #  '';
  # };

}
