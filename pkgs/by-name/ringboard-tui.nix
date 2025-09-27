{
  rustPlatform_nightly,
  ringboard-server,
}:
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-tui";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "tui";
  inherit (ringboard-server) cargoDeps;

  strictDeps = true;

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      platforms
      ;
    description = "TUI for Ringboard, a clipboard manager for Linux";
    mainProgram = "ringboard-tui";
  };
}
