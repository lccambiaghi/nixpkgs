{

  customPython = pkgs.python37.buildEnv.override {
    extraLibs = with pkgs.python37Packages; [
      black
      # debugpy
      flake8
      ipython
      isort
      # jupyter
      pip
      pyyaml
      # tabulate
    ];
  };

  home.packages = with pkgs; [
      python37Packages.poetry
      customPython
  ];

}