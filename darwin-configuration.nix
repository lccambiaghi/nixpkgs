{ inputs, config, pkgs, ... }:
{
  imports = [
    ./modules/darwin_modules
    ./modules/system.nix
  ];

  # environment setup
  environment = {
    # loginShell = pkgs.fish;
    pathsToLink = [ "/Applications" ];
    etc = {
      darwin.source = "${inputs.darwin}";
    };
    # systemPackages = [ ];
    extraInit = ''
      # install homebrew
      command -v brew > /dev/null || ${pkgs.bash}/bin/bash -c "$(${pkgs.curl}/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    '';
    systemPath = [
      "/run/current-system/sw/bin/" # TODO how to avoid hardcoding?
      "$HOME/.poetry/bin"
      # "$HOME/.emacs.d/bin"
      "$HOME/git/doom-emacs/bin"
    ];
    variables = {
      EDITOR = "emacsclient";
      KUBE_EDITOR="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
      LIBRARY_PATH="/usr/bin/gcc";
      CLOJURE_LOAD_PATH="$HOME/git/clojure-clr/bin/4.0/Release/"; # NOTE this needs to be present and compiled
      EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs";
      SHELL = "/run/current-system/sw/bin/zsh"; # TODO how to avoid hardcoding?
      # BROWSER = "firefox";
      # OPENTYPEFONTS="$HOME/.nix-profile/share/fonts/opentype//:";
    };

  };

  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];

  programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.bash.enable = true;

  programs.nix-index.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
