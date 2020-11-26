{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {url = https://github.com/mjlbach/emacs-pgtk-nativecomp-overlay/archive/master.tar.gz;}))
  ];

  programs.emacs = {
    enable = true;
    # package = pkgs.emacsWithPackagesFromUsePackage {
    #   package = emacs-darwin;
    #   config = "$HOME/.emacs.d/init.el";
    # };
    package = pkgs.emacsGcc;
  };


}
