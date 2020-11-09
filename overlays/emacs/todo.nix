# https://github.com/nix-community/emacs-overlay
#
# https://github.com/nix-community/emacs-overlay/issues/71

{ config, pkgs, libs, ... }:

let
  sources = import ../nix/sources.nix;
  nixos-unstable = import sources.nixos-unstable { };
in

{
  programs.emacs = {
    enable = true;
    package = nixos-unstable.emacsGccPgtk;
    # extraPackages = (epkgs: [ epkgs.vterm ] );
  };

}

