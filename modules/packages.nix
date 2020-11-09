{ pkgs }:

with pkgs; [
  clang
  gnumake
  gnupg
  htop
  jq
  nixops
  nix-prefetch-git
  pass
  python3
  ripgrep
  rsync
  vim
  wget
  wireguard-tools
  youtube-dl

  # Docker
  docker

  # k8s
  argocd
  kubectl
  kubectx
  kustomize
]
