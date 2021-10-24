{

  R-with-pkgs = pkgs.rWrapper.override{ packages = with pkgs.rPackages; [
    IRkernel
    ISLR
  ]; };

  home.packages = [
      R-with-pkgs
  ];

}