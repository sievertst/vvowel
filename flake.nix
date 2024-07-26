{
  description = "LaTeX package for typesetting linguistic vector graphics vowel diagrams";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixfmt.url = "github:NixOS/nixfmt";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, system, ... }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pname = "vvowel";
        in
        {
          packages.default = pkgs.stdenvNoCC.mkDerivation rec {
            inherit pname;
            version = "0.1";
            outputs = [ "tex" ];
            src = self;
            nativeBuildInputs = [
              (pkgs.writeShellScript "force-tex-output.sh" ''
                out="''${tex-}"
              '')
            ];
            installPhase = ''
              runHook preInstall
              path="$tex/tex/latex/${pname}"
              mkdir -p "$path"
              cp *.{sty,cls,def,clo} "$path"
              runHook postInstall
            '';
          };

          formatter = inputs.nixfmt.packages.${system}.default;
        };
    };
}
