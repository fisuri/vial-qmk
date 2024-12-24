{
  description = "test";
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
    pkgsFor = nixpkgs.legacyPackages;
  in {
    devShells = forAllSystems (system: {
      default = pkgsFor.${system}.callPackage ./shell.nix {};
    });
  };
}
