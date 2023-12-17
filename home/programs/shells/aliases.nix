{ pkgs, ... }:

{
  # Set all shell aliases programatically
  shellAliases = {
    # Aliases for commonly used tools
    cat = "bat";

    ls = "${pkgs.eza}/bin/eza";
    ll = "${pkgs.eza}/bin/eza -lh";
    lt = "${pkgs.eza}/bin/eza --tree";

    # Nix garbage collection
    garbage = "sudo nix-collect-garbage -d && docker image prune --all --force";

    # See which Nix packages are installed with nix-env
    installed = "nix-env --query --installed";

    # emacs
    # emacs="/Applications/Emacs.app/Contents/MacOS/Emacs";
    # emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
    em="emacsclient -a \"\" -n";

    brew86="arch -x86_64 /usr/local/bin/brew";
  };
}
