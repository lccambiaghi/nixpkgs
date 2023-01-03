{ pkgs, ... }:

{
  # Set all shell aliases programatically
  shellAliases = {
    # Aliases for commonly used tools
    grep = "grep --color=auto";
    cat = "bat";

    # first Create Command-line Launcher
    ds="/usr/local/bin/dataspell";

    vmstart="az vm start -g rgpazewpmlit-forecasting-tooling-001 -n avocado-ds-vm";

    find = "fd";

    l = "${pkgs.exa}/bin/exa";
    ls = "${pkgs.exa}/bin/exa";
    la = "${pkgs.exa}/bin/exa -la";
    ll = "${pkgs.exa}/bin/exa -lh";
    lt = "${pkgs.exa}/bin/exa --tree";

    k = "kubectl";
    ke = "kubectl edit";
    kx = "kubectl exec -ti ";
    kp = "kubectl get pods";
    kj = "kubectl get jobs";
    kc = "kubectl get cronjobs";
    kl = "kubectl logs";
    klf = "kubectl logs -f ";
    wkp= "watch -n 1 kubectl get pods";
    kpr= "kubectl get pods --field-selector status.phase=Running";
    wkpr= "watch -n 1 kubectl get pods --field-selector status.phase=Running";
    kga= "kubectl get all";
    kgj= "kubectl get jobs";
    kdl= "kubectl delete ";
    kds= "kubectl describe ";
    pj= "python $HOME/bin/pretty_json.py";

    cljclr="mono $CLOJURE_LOAD_PATH/Clojure.Main.exe";

    pipde = "poetry run pip install debugpy";
    pipdt = "poetry run pip install dtale";

    # Reload home manager and zsh
    reload = "cd ~/git/nixpkgs && darwin-rebuild switch --flake .#macbookpro && cd -";

    # Nix garbage collection
    garbage = "sudo nix-collect-garbage -d && docker image prune --all --force";

    # See which Nix packages are installed with nix-env
    installed = "nix-env --query --installed";

    # emacs
    # emacs="/Applications/Emacs.app/Contents/MacOS/Emacs";
    # emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient";
    em="emacsclient -a \"\" -n";

    brew86="arch -x86_64 /usr/local/homebrew/bin/brew";
  };
}
