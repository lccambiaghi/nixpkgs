{ lib, config, pkgs, ... }:

with lib; {
  imports = attrValues (import ./modules);
  networking.hostName = "luca-macbookpro";

  system.stateVersion = 4;
}
