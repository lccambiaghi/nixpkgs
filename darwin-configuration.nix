{ lib, config, pkgs, ... }:

with lib; {
  imports = [
    ./modules/config.nix
    ./modules/homebrew.nix
    (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nix-darwin")
  ];

  system.stateVersion = 4;
}
