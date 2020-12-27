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
    clojure = {
      source = ./clojure;
      target = ".clojure";
      recursive = true;
    };
    ipython = {
      source = ./ipython;
      target = ".ipython";
      recursive = true;
    };
    ".npmrc".text = "prefix = ${homeDir}/.npm-packages";
  };
  xdg = {
    enable = true;
    # configHome = "${homeDir}/.config";
    # dataHome   = "${homeDir}/.local/share";
    # cacheHome  = "${homeDir}/.cache";
    configFile = {
      nixpkgs = {
        source = ./../..;
        recursive = true;
      };
      direnv = {
        source = ./direnv;
        recursive = true;
      };
      kitty = {
        source = ./kitty;
        recursive = true;
      };
      # ".config/kitty/macos-launch-services-cmdline".text = "--listen-on unix:/tmp/mykitty";
      # "gnupg/gpg-agent.conf".text = ''
      #   enable-ssh-support
      #   default-cache-ttl 86400
      #   max-cache-ttl 86400
      #   pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      # '';
    };
  };

  # file.".emacs.d" = {
  #   source = "$HOME/.emacs.d";
  #   recursive = true;
  # };
}
