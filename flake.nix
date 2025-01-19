{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = nixpkgs.legacyPackages;
  in {
    packages = forAllSystems (system: {
      buildLotus58 = pkgs.${system}.callPackage ./default.nix {buildKeyboard = "lotus58";};
      buildYmd40v2 = pkgs.${system}.callPackage ./default.nix {buildKeyboard = "ymd40";};
    });

    devShells = forAllSystems (system: {
      default = pkgs.${system}.callPackage ./shell.nix {};
    });
  };
}
