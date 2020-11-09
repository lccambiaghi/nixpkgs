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
