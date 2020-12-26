{ inputs, config, pkgs, ... }:
{
  imports = [
    ./modules/darwin_modules
    ./modules/common.nix
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
      "$HOME/.poetry/bin"
      "$HOME/.emacs.d/bin"
    ];
    variables = {
      EDITOR = "emacsclient";
      KUBE_EDITOR="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
      LIBRARY_PATH="/usr/bin/gcc";
      CLOJURE_LOAD_PATH="$HOME/git/clojure-clr/bin/4.0/Release/"; # NOTE this needs to be present and compiled
      EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs";
      SHELL = "/etc/profiles/per-user/luca/bin/fish";
      # TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
      # BROWSER = "firefox";
      # OPENTYPEFONTS="$HOME/.nix-profile/share/fonts/opentype//:";
    };

  };

  nix.nixPath = [ "darwin=/etc/${config.environment.etc.darwin.target}" ];

  # Overlay for temporary fixes to broken packages on nixos-unstable
  nixpkgs.overlays = [
    (self: super:
      let
        # Import nixpkgs at a specified commit
        importNixpkgsRev = { rev, sha256 }:
          import (builtins.fetchTarball {
            name = "nixpkgs-src-" + rev;
            url = "https://github.com/NixOS/nixpkgs/archive/" + rev + ".tar.gz";
            inherit sha256;
          }) {
            system = "x86_64-darwin";
            inherit (config.nixpkgs) config;
            overlays = [ ];
          };

        stable = import inputs.stable {
          system = "x86_64-darwin";
          inherit (config.nixpkgs) config;
          overlays = [ ];
        };
      in { })
  ];

  programs.fish.enable = true;
  programs.zsh.enable = true;
  programs.bash.enable = true;

  programs.nix-index.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 4;
}
