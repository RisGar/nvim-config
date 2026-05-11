{
  description = "Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

        in
        rec {
          nvim = pkgs.callPackage ./. { };
          default = nvim;
        }
      );

      devShells = forEachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = [ self.packages.${system}.default ];
        };
      });
    };
}
