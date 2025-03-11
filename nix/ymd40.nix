{common}: let
  inherit (common) build_firmware;

  build_ymd40 = build_firmware {
    keyboard = "ymd40";
    keymap = "vial";
    rev = "v2";

    outputName = "fisuri_ymd40_vial_MASTER";
  };
in
  build_ymd40
