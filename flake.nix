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
          inherit system inputs;
        };
      in {
        packages = {
          lotus58 = pkgs.callPackage ./default.nix {buildKeyboard = "lotus58";};
          ymd40v2 = pkgs.callPackage ./default.nix {buildKeyboard = "ymd40";};
          klor = pkgs.callPackage ./default.nix {buildKeyboard = "klor";};
          sofle = pkgs.callPackage ./default.nix {buildKeyboard = "sofle";};
        };

        devShells = {
          default = pkgs.callPackage ./shell.nix {};
        };
      }
    );
}
