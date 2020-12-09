{ ... }:

let
  user_name = "luca";

in
{
  homebrew = {
    enable = true;
    formulae = [
      "borkdude/brew/babashka"
      "kubectx"
      "libvterm"
      "mas"
      "mono"
      "nuget"
      "parquet-tools"
    ];
    cask_args.appdir = "/Users/${user_name}/Applications";
    casks = [
      "authy"
      # "altserver"
      # "amethyst"
      # "1password"
      # "iina"
      # "discord"
      # "docker"
      # "dropbox"
      # "google-chrome"
      # "keybase" # maybe enable in home-manager
      # "menumeters"
      # "microsoft-azure-storage-explorer"
      # "microsoft-office"
      # "microsoft-teams"
      # "private-internet-access"
      # "pycharm-ce"
      # "qbitorrent"
      # "slack"
    ];
    taps = [
      "borkdude/brew"
    ];
  };
}
