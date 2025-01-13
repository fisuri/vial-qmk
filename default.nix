{
  pkgs ? import <nixpkgs> {},
  buildType ? "all",
}: let
  repoBranch = "feature/add_fisuri_lotus58";
  repoOwner = "fisuri";
  repo = "qmk_firmware";
  repoRev = "refs/heads/${repoBranch}";
  repoSHA256 = "sha256-rYHM6cS1XwnchLIN1wD/P4LAxirHKpg7S5/FJe4SY6Y=";

  src = pkgs.fetchFromGitHub {
    owner = repoOwner;
    repo = repo;
    rev = repoRev;
    sha256 = repoSHA256;
    fetchSubmodules = true;
  };

  keyboard = "lotus58";
  keyboardRev = "promicro";
  keymap = "vial";

  buildFirmware = {
    keyboard,
    rev,
    keymap,
    outputName,
    usbDetectEnabled,
  }:
    pkgs.stdenv.mkDerivation {
      inherit src;

      name = "build-${keyboard}-${rev}-${keymap}-${buildType}";

      nativeBuildInputs = with pkgs; [
        gnumake
        qmk
      ];

      buildPhase = ''
        sed -i "s/\"usb_detect\": {[^}]*\"enabled\": .*/\"usb_detect\": { \"enabled\": ${toString usbDetectEnabled} }/" keyboards/fisuri/${keyboard}/info.json

        # Сборка прошивки
        make fisuri/${keyboard}/${rev}:${keymap}
        mv fisuri_${keyboard}_${rev}_${keymap}.hex ${outputName}.hex
      '';

      installPhase = ''
        mkdir -p $out
        mv ${outputName}.hex $out/
      '';
    };

  buildMaster = buildFirmware {
    keyboard = keyboard;
    rev = keyboardRev;
    keymap = keymap;
    outputName = "fisuri_${keyboard}_${keyboardRev}_${keymap}_MASTER";
    usbDetectEnabled = false;
  };

  buildSlave = buildFirmware {
    keyboard = keyboard;
    rev = keyboardRev;
    keymap = keymap;
    outputName = "fisuri_${keyboard}_${keyboardRev}_${keymap}_SLAVE";
    usbDetectEnabled = true;
  };

  buildAll = pkgs.stdenv.mkDerivation {
    inherit src;

    name = "build-all";

    buildInputs = [buildMaster buildSlave];

    buildPhase = ''
      echo "Building all firmware versions..."
    '';

    installPhase = ''
      mkdir -p $out
      ls ${buildMaster}
      ls ${buildSlave}

      cp ${buildMaster}/fisuri_${keyboard}_${keyboardRev}_${keymap}_MASTER.hex $out/
      cp ${buildSlave}/fisuri_${keyboard}_${keyboardRev}_${keymap}_SLAVE.hex $out/
      echo "All builds completed."
    '';
  };
in
  if buildType == "all"
  then buildAll
  else if buildType == "master"
  then buildMaster
  else buildSlave
# {
#   inherit buildMaster buildSlave;
# }
# pkgs.stdenv.mkDerivation {
#   name = "build-master";
#
#   src = pkgs.fetchFromGitHub {
#     owner = "fisuri";
#     repo = "vial-qmk";
#     rev = "refs/heads/feature/add_fisuri_lotus58";
#     sha256 = "sha256-JqivO9P3tznAnpiS4QVwfb0YLSsRCUf4OFEqO+wBqDA=";
#     fetchSubmodules = true;
#   };
#
#   nativeBuildInputs = with pkgs; [
#     gnumake
#     qmk
#     libgcc
#     git
#   ];
#
#   # unpackPhase = ''
#   #   git submodule update --init --recursive
#   # '';
#
#   buildPhase = ''
#       make fisuri/lotus58/promicro:vial
#       mv fisuri_lotus58_promicro_vial.hex fisuri_lotus58_promicro_vial_MASTER.hex
#     # qmk compile -kb fisuri/lotus58/promicro -km vial
#     # make git-submodule
#   '';
#
#   installPhase = ''
#     mkdir -p $out
#     mv fisuri_lotus58_promicro_vial_MASTER.hex $out/
#   '';
# }

