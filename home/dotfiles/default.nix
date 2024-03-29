{ config, pkgs, ... }:

{
  home.file = {
    # brewfile = {
    #   source = ./Brewfile;
    #   target = "Brewfile";
    # };
    amethyst = {
      source = ./amethyst.yml;
      target = ".amethyst.yml";
    };
    clojure = {
      source = ./clojure;
      target = ".clojure";
      recursive = true;
    };
    ideavimrc = {
      source = ./ideavimrc;
      target = ".ideavimrc";
    };
    ipython = {
      source = ./ipython;
      target = ".ipython";
      recursive = true;
    };
    # ".npmrc".text = "prefix = ${HOME}/.npm-packages";
    ".lintr".text = ''
linters: with_defaults(
  line_length_linter(120),
  commented_code_linter = NULL
)
exclude: "# Exclude Linting"
exclude_start: "# Begin Exclude Linting"
exclude_end: "# End Exclude Linting"

    '';
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
