{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    qmk
    gnumake
  ];

  buildInputs = with pkgs; [
  ];
}
