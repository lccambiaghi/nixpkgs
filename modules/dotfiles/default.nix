{ config, pkgs, ... }:

let
  homeDir = "/Users/luca";
in
{
  home.file = {
    # brewfile = {
    #   source = ./Brewfile;
    #   target = "Brewfile";
    # };
    # keras = {
    #   source = ./keras;
    #   target = ".keras";
    #   recursive = true;
    # };
    ".clojure/deps.edn".source = ./deps.edn;
    ".ipython/profile_default/startup/2-pandas.py".source = ./2-pandas.py;
    ".npmrc".text = "prefix = ${homeDir}/.npm-packages";
    # TODO maybe use xdg.config for these?
    ".config/direnv/direnvrc".source = ./direnvrc;
    ".config/kitty/modus-operandi.conf".source = ./modus-operandi.conf;
    ".config/kitty/modus-vivendi.conf".source = ./modus-vivendi.conf;
    ".config/kitty/macos-launch-services-cmdline".text = "--listen-on unix:/tmp/mykitty";
  };

  # xdg.configFile = {
  #   nixpkgs = {
  #     source = ./../..;
  #     recursive = true;
  #   };
  # };

  # file.".config/nix/nix.conf".text = ''
  #   substituters = https://cache.nixos.org https://cache.nixos.org/ https://mjlbach.cachix.org
  #   trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= mjlbach.cachix.org-1:dR0V90mvaPbXuYria5mXvnDtFibKYqYc2gtl9MWSkqI=
  # '';

  # file.".emacs.d" = {
  #   source = "$HOME/.emacs.d";
  #   recursive = true;
  # };
}
