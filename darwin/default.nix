{ inputs, pkgs, lib, ... }:

{
  imports = [
    ./brew.nix
    ./preferences.nix
    # ./spacebar.nix
  ];

  #####################
  # Nix configuration #
  #####################

  # nixpkgs.overlays = [
    # inputs.nur.overlay
    # inputs.emacs-overlay.overlay
  # ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Disable nix-darwin managing Nix as it is already managed by Determinate
  nix.enable = false;
  # services.nix-daemon.enable = false;

  ########################
  # System configuration #
  ########################

  # Fonts
  # networking = {
  #   dns = [
  #     "1.1.1.1"
  #     "8.8.8.8"
  #   ];
  # };

  # time.timeZone = "Europe/Paris";

  ################
  # environment #
  ################

  environment = {
    extraInit = ''
      # install homebrew
      command -v brew > /dev/null || ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    '';
    # loginShell = pkgs.fish;
    pathsToLink = [ "/Applications" ];
    shells = [ pkgs.zsh ];
    # systemPackages = [ ];
    systemPath = [
      # "/run/current-system/sw/bin/" # TODO how to avoid hardcoding?
      "$HOME/.npm-packages/bin"
      "$HOME/.poetry/bin"
      "/Users/cambiaghiluca/.modular/pkg/packages.modular.com_mojo/bin"
      # "$HOME/.emacs.d/bin"
      # "$HOME/git/doom-emacs/bin"
      # "/opt/homebrew/bin"
      # "/usr/local/homebrew/bin"
      # TODO: /usr/local/bin
      # "$HOME/bin"
    ];
    variables = {
      EDITOR = "emacsclient";
      KUBE_EDITOR="emacsclient";
      LC_ALL="en_US.UTF-8";
      # CLOJURE_LOAD_PATH="$HOME/git/clojure-clr/bin/4.0/Release/"; # NOTE this needs to be present and compiled
      EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs";
      SHELL = "${pkgs.zsh}/bin/zsh";
      LIBRARY_PATH="$(brew --prefix)/lib";
      CPATH="$(brew --prefix)/include";
      CFLAGS="-I$(brew --prefix openssl)/include";
      LDFLAGS="-L$(brew --prefix openssl)/lib";
      MODULAR_HOME="$HOME/.modular";
      # OPENSSL_ROOT_DIR="/opt/homebrew/Cellar/openssl@3/3.0.7/";
      # BROWSER = "firefox";
      # OPENTYPEFONTS="$HOME/.nix-profile/share/fonts/opentype//:";
    };

  };

  programs.fish.enable = false;
  programs.zsh.enable = true;
  programs.bash.enable = true;
  programs.nix-index.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
