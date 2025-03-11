{
  pkgs,
  common,
}: let
  inherit (common) build_firmware_without_rev;

  build_klor = build_firmware_without_rev {
    keyboard = "klor";
    keymap = "vial";

    outputName = "fisuri_klor_vial_MASTER";
  };
in
  build_klor
