{
  pkgs ? import <nixpkgs> {},
  buildKeyboard,
  lib,
}: let
  repoBranch = "vial";
  repoOwner = "fisuri";
  repo = "vial-qmk";
  repoRev = "refs/heads/${repoBranch}";

  # repoSHA256 = "";
  repoSHA256 = lib.fakeHash;

  src = pkgs.fetchFromGitHub {
    owner = repoOwner;
    repo = repo;
    rev = repoRev;
    sha256 = repoSHA256;
    fetchSubmodules = true;
  };

  keyboard = buildKeyboard;
  keymap = "vial";

  buildFirmware = {
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

  buildFirmwareWithoutRev = {
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

  buildLotus58 = {isMaster}: let
    mode =
      if isMaster
      then "MASTER"
      else "SLAVE";

    usbDetect =
      if isMaster
      then "false"
      else "true";
  in
    buildFirmware {
      inherit keyboard keymap;

      rev = "promicro";
      outputName = "fisuri_${keyboard}_${keymap}_${mode}";
      customBuildPhase = ''
        jq '.split.usb_detect.enabled = ${usbDetect}' keyboards/fisuri/${keyboard}/info.json > tmp.json && mv tmp.json keyboards/fisuri/${keyboard}/info.json
      '';
    };

  lotus58BuildConfigs = [
    {isMaster = true;}
    {isMaster = false;}
  ];

  buildLotus58All =
    pkgs.stdenv.mkDerivation
    {
      inherit src;

      name = "build-lotus58-all";

      buildInputs = map buildLotus58 lotus58BuildConfigs;

      buildPhase = ''
        echo "Building lotus58 all firmware versions..."
      '';

      installPhase = ''
        mkdir -p $out

        cp ${buildLotus58 {isMaster = true;}}/fisuri_${keyboard}_${keymap}_MASTER.hex $out/
        cp ${buildLotus58 {isMaster = false;}}/fisuri_${keyboard}_${keymap}_SLAVE.hex $out/
        echo "All builds completed."
      '';
    };

  buildYmd40v2 = buildFirmware {
    inherit keyboard keymap;

    rev = "v2";
    outputName = "fisuri_${keyboard}_${keymap}_MASTER";
  };

  buildKlor = buildFirmwareWithoutRev {
    inherit keyboard keymap;

    outputName = "fisuri_${keyboard}_${keymap}_MASTER";
  };
in
  if buildKeyboard == "ymd40"
  then buildYmd40v2
  else if buildKeyboard == "lotus58"
  then buildLotus58All
  else if buildKeyboard == "klor"
  then buildKlor
  else null
