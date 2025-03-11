{
  pkgs,
  common,
}: let
  inherit (common) src build_firmware build_configs;

  build_lotus58 = {isMaster}: let
    mode =
      if isMaster
      then "MASTER"
      else "SLAVE";

    usbDetect =
      if isMaster
      then "false"
      else "true";
  in
    build_firmware {
      keyboard = "lotus58";
      keymap = "vial";
      rev = "promicro";
      outputName = "fisuri_lotus58_vial_${mode}";
      customBuildPhase = ''
        jq '.split.usb_detect.enabled = ${usbDetect}' keyboards/fisuri/lotus58/info.json > tmp.json && mv tmp.json keyboards/fisuri/lotus58/info.json
      '';
    };

  build_lotus58_all =
    pkgs.stdenv.mkDerivation
    {
      inherit src;

      name = "build-lotus58-all";

      buildInputs = map build_lotus58 build_configs;

      buildPhase = ''
        echo "Building lotus58 all firmware versions..."
      '';

      installPhase = ''
        mkdir -p $out

        cp ${build_lotus58 {isMaster = true;}}/fisuri_lotus58_vial_MASTER.hex $out/
        cp ${build_lotus58 {isMaster = false;}}/fisuri_lotus58_vial_SLAVE.hex $out/
        echo "All builds completed."
      '';
    };
in
  build_lotus58_all
