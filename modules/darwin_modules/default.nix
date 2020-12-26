{ pkgs, ... }: {
  imports = [ ./preferences.nix ./homebrew-bundle.nix ./brew.nix ];
}
