{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

        fakeHash = pkgs.lib.fakeHash;

        common = import ./nix/common.nix {inherit pkgs fakeHash;};
      in {
        packages = {
          lotus58 = pkgs.callPackage ./nix/lotus58.nix {inherit pkgs common;};
          ymd40 = pkgs.callPackage ./nix/ymd40.nix {inherit common;};
          klor = pkgs.callPackage ./nix/klor.nix {inherit pkgs common;};
          sofle = pkgs.callPackage ./nix/sofle.nix {inherit pkgs common;};

          # inherit lotus58 ymd40v2 klor sofle;

          # lotus58 = pkgs.callPackage ./default.nix {buildKeyboard = "lotus58";};
          # ymd40v2 = pkgs.callPackage ./default.nix {buildKeyboard = "ymd40";};
          # klor = pkgs.callPackage ./default.nix {buildKeyboard = "klor";};
          # sofle = pkgs.callPackage ./default.nix {buildKeyboard = "sofle";};
        };

        devShells = {
          default = pkgs.callPackage ./shell.nix {};
        };
      }
    );
}
