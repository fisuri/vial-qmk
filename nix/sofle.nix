{
  pkgs,
  common,
}: let
  inherit (common) src build_firmware build_configs;

  build_sofle = {isMaster}: let
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
      keyboard = "sofle";
      keymap = "vial";
      rev = "rev1";

      outputName = "fisuri_sofle_vial_${mode}";

      customBuildPhase = ''
        jq '.split.usb_detect.enabled = ${usbDetect}' keyboards/fisuri/sofle/info.json > tmp.json && mv tmp.json keyboards/fisuri/sofle/info.json
      '';
    };

  build_sofle_all =
    pkgs.stdenv.mkDerivation
    {
      inherit src;

      name = "build-sofle-all";

      buildInputs = map build_sofle build_configs;

      buildPhase = ''
        echo "Building sofle all firmware versions..."
      '';

      installPhase = ''
        mkdir -p $out

        cp ${build_sofle {isMaster = true;}}/fisuri_sofle_vial_MASTER.hex $out/
        cp ${build_sofle {isMaster = false;}}/fisuri_sofle_vial_SLAVE.hex $out/
        echo "All builds completed."
      '';
    };
in
  build_sofle_all
