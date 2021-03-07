{ ... }:

let
  user_name = "luca";

in
{

  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;

  homebrew = {
    brews = [
      "borkdude/brew/babashka"
      "kubectx"
      "libvterm"
      # "mas"
      # "mono"
      # "nuget"
      # "parquet-tools"
      # "crescentrose"/sunshine
    ];
    # cask_args.appdir = "/Users/${user_name}/Applications";
    casks = [
      # "authy"
      # "altserver"
      # "amethyst"
      # "1password"
      # "iina"
      # "discord"
      # "docker"
      # "dozer"
      # "dropbox"
      # "google-chrome"
      # "keybase" # maybe enable in home-manager
      "karabiner-elements"
      # "menumeters"
      # "microsoft-azure-storage-explorer"
      # "microsoft-office"
      # "microsoft-teams"
      # "private-internet-access"
      # "pycharm-ce"
      # "qbitorrent"
      # "slack"
    ];
    # taps = [
      # "borkdude/brew"
      # "homebrew/cask-fonts"
      # "crescentrose/sunshine"
    # ];
  };
}
