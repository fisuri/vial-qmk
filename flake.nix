{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages = {
          buildLotus58 = pkgs.callPackage ./default.nix {buildKeyboard = "lotus59";};
          buildYmd40v2 = pkgs.callPackage ./default.nix {buildKeyboard = "ymd40";};
        };

        devShells = {
          default = pkgs.callPackage ./shell.nix {};
        };
      }
    );
}
