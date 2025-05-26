{
  lib,
  rustPlatform_nightly,
  ringboard-server,

  autoPatchelfHook,
  pkg-config,

  stdenv,
  fontconfig,
  libxkbcommon,
  libGL,

  waylandSupport ? true,
  wayland,

  x11Support ? true,
  xorg,
}:
let
  inherit (lib) flatten;
in
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-egui";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "egui";

  cargoHash = "sha256-+E6BzfgUvpBZzkzvPvFfEt/IoVR/wU4uHECs4Dn5pIE=";

  strictDeps = true;

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
  ];
  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = flatten [
    "system-fonts"
    (lib.optional waylandSupport "wayland")
    (lib.optional x11Support "x11")
  ];

  runtimeDependencies = flatten [
    libxkbcommon
    libGL
    (lib.optionals waylandSupport [ wayland ])
    (lib.optionals x11Support [
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
    ])
  ];

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      platforms
      ;
    description = "GUI for Ringboard, a clipboard manager for Linux";
    mainProgram = "ringboard-egui";
  };
}
