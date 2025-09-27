{
  lib,
  rustPlatform_nightly,
  ringboard-server,

  autoPatchelfHook,
  pkg-config,

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
  inherit (ringboard-server) cargoDeps;

  strictDeps = true;

  buildInputs = [
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
