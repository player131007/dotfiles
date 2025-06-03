{
  rustPlatform_nightly,
  ringboard-server,
}:
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-wayland";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "wayland";
  inherit (ringboard-server) cargoDeps;

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
