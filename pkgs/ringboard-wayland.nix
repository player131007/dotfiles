{
  rustPlatform_nightly,
  ringboard-server,
}:
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-wayland";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "wayland";

  cargoHash = "sha256-+E6BzfgUvpBZzkzvPvFfEt/IoVR/wU4uHECs4Dn5pIE=";

  strictDeps = true;

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      platforms
      ;
    description = "Wayland clipboard watcher for Ringboard, a clipboard manager for Linux";
    mainProgram = "ringboard-wayland";
  };
}
