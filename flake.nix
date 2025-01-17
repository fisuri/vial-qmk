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
    pkgs = nixpkgs.legacyPackages;
  in {
    packages = forAllSystems (system: {
      buildMaster = pkgs.${system}.callPackage ./default.nix {buildType = "master";};
      buildSlave = pkgs.${system}.callPackage ./default.nix {buildType = "slave";};
      buildAll = pkgs.${system}.callPackage ./default.nix {buildType = "all";};
    });

    # packages = forAllSystems.buildSlave (system: {
    #   default = pkgs.${system}.callPackage ./default.nix {};
    # });
    # packages = forAllSystems.buildAll (system: {
    #   default = pkgs.${system}.callPackage ./default.nix {};
    # });

    devShells = forAllSystems (system: {
      default = pkgs.${system}.callPackage ./shell.nix {};
    });
  };
}
