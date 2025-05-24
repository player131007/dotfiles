{
  rustPlatform_nightly,
  ringboard-server,
}:
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-tui";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "tui";

  cargoHash = "sha256-+E6BzfgUvpBZzkzvPvFfEt/IoVR/wU4uHECs4Dn5pIE=";

  meta = {
    inherit (ringboard-server.meta) homepage changelog license platforms;
    description = "TUI for Ringboard, a clipboard manager for Linux";
    mainProgram = "ringboard";
  };
}

