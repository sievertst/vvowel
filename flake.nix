{
  description = "LaTeX package for typesetting linguistic vowel diagrams";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.default = pkgs.stdenvNoCC.mkDerivation rec {
        name = "vvowel";
        src = self;
        installPhase = ''
          mkdir -p $out/tex/latex
          cp vvowel.sty $out/tex/latex
        '';
      };
    });
}
