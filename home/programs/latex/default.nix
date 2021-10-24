{
    program.texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs)
          dvipng
          # xetex
          # latexmk 
          # scheme-full
          scheme-small;
      };
    };

    # home.packages = with pkgs; [
    #   tectonic
    # ];

}