{
  rustPlatform_nightly,
  ringboard-server,
}:
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-cli";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "cli";

  strictDeps = true;

  cargoHash = "sha256-+E6BzfgUvpBZzkzvPvFfEt/IoVR/wU4uHECs4Dn5pIE=";

  meta = {
    inherit (ringboard-server.meta) homepage changelog license platforms;
    description = "CLI for Ringboard, a clipboard manager for Linux";
    mainProgram = "ringboard";
  };
}
