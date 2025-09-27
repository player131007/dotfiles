{
  rustPlatform_nightly,
  ringboard-server,
}:
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-x11";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "x11";
  inherit (ringboard-server) cargoDeps;

  strictDeps = true;

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      platforms
      ;
    description = "X11 clipboard watcher for Ringboard, a clipboard manager for Linux";
    mainProgram = "ringboard-x11";
  };
}
