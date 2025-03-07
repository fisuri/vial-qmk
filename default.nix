{
  pkgs ? import <nixpkgs> {},
  buildKeyboard,
  lib,
}: let
  owner = "fisuri";
  repo = "vial-qmk";
  branch = "vial";
  rev = "refs/heads/${branch}";

  sha256 = "sha256-Is0Ehq5i1LQE2JkrI9BKv5UNEIRitycqCnR9gqoT8nw=";
  # sha256 = lib.fakeHash;

  src = pkgs.fetchFromGitHub {
    inherit owner repo rev sha256;

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

  buildConfigs = [
    {isMaster = true;}
    {isMaster = false;}
  ];

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

  buildLotus58All =
    pkgs.stdenv.mkDerivation
    {
      inherit src;

      name = "build-lotus58-all";

      buildInputs = map buildLotus58 buildConfigs;

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

  buildSofle = {isMaster}: let
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

      rev = "rev1";
      outputName = "fisuri_${keyboard}_${keymap}_${mode}";
      customBuildPhase = ''
        jq '.split.usb_detect.enabled = ${usbDetect}' keyboards/fisuri/${keyboard}/info.json > tmp.json && mv tmp.json keyboards/fisuri/${keyboard}/info.json
      '';
    };

  buildSofleAll =
    pkgs.stdenv.mkDerivation
    {
      inherit src;

      name = "build-sofle-all";

      buildInputs = map buildSofle buildConfigs;

      buildPhase = ''
        echo "Building sofle all firmware versions..."
      '';

      installPhase = ''
        mkdir -p $out

        cp ${buildSofle {isMaster = true;}}/fisuri_${keyboard}_${keymap}_MASTER.hex $out/
        cp ${buildSofle {isMaster = false;}}/fisuri_${keyboard}_${keymap}_SLAVE.hex $out/
        echo "All builds completed."
      '';
    };
in
  if buildKeyboard == "ymd40"
  then buildYmd40v2
  else if buildKeyboard == "lotus58"
  then buildLotus58All
  else if buildKeyboard == "klor"
  then buildKlor
  else if buildKeyboard == "sofle"
  then buildSofleAll
  else null
