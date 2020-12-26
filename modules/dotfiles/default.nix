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
