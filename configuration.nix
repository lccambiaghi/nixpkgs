{ lib, config, pkgs, ... }:

with lib; {
  imports = attrValues (import ./modules);
  networking.hostName = "luca-macbookpro";

  # services.lorri.enable = true;
  # services.nix-daemon.enable = true;

  system.stateVersion = 4;
}
