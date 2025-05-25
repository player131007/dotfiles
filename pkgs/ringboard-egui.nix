{
  rustPlatform_nightly,
  ringboard-server,
}:
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-egui";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "egui";

  cargoHash = "sha256-+E6BzfgUvpBZzkzvPvFfEt/IoVR/wU4uHECs4Dn5pIE=";

  meta = {
    inherit (ringboard-server.meta) homepage changelog license platforms;
    broken = true; # egui
    description = "GUI for Ringboard, a clipboard manager for Linux";
    mainProgram = "ringboard-egui";
  };
}

