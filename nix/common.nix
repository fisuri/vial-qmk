# common.nix
{
  pkgs,
  fakeHash,
}: let
  owner = "fisuri";
  repo = "vial-qmk";
  branch = "vial";
  rev = "refs/heads/${branch}";

  sha256 = "sha256-Ro6fe8hIEgV78BuCUvH8Hy+r21pfmMDf0S28RHwN+oU=";
  # sha256 = fakeHash;

  src = pkgs.fetchFromGitHub {
    inherit owner repo rev sha256;
    fetchSubmodules = true;
  };

  build_configs = [
    {isMaster = true;}
    {isMaster = false;}
  ];

  build_firmware = {
    keyboard,
    rev,
    keymap,
    outputName,
    customBuildPhase ? '''',
  }:
    pkgs.stdenv.mkDerivation {
      inherit src;

      name = "build-${keyboard}-${rev}-${keymap}";

      nativeBuildInputs = with pkgs; [
        gnumake
        qmk
        jq
      ];

      buildPhase = ''
        ${customBuildPhase}

        # Сборка прошивки
        make fisuri/${keyboard}/${rev}:${keymap}
        mv fisuri_${keyboard}_${rev}_${keymap}.hex ${outputName}.hex
      '';

      installPhase = ''
        mkdir -p $out
        mv ${outputName}.hex $out/
      '';
    };

  build_firmware_without_rev = {
    keyboard,
    keymap,
    outputName,
    customBuildPhase ? '''',
  }:
    pkgs.stdenv.mkDerivation {
      inherit src;

      name = "build-${keyboard}-${keymap}";

      nativeBuildInputs = with pkgs; [
        gnumake
        qmk
        jq
      ];

      buildPhase = ''
        ${customBuildPhase}

        # Сборка прошивки
        make fisuri/${keyboard}:${keymap}
        mv fisuri_${keyboard}_${keymap}.hex ${outputName}.hex
      '';

      installPhase = ''
        mkdir -p $out
        mv ${outputName}.hex $out/
      '';
    };
in {
  inherit src build_configs build_firmware build_firmware_without_rev;
}
