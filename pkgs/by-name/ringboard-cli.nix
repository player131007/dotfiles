{
  rustPlatform_nightly,
  ringboard-server,
}:
rustPlatform_nightly.buildRustPackage {
  pname = "ringboard-cli";
  inherit (ringboard-server) version src;

  buildAndTestSubdir = "cli";
  inherit (ringboard-server) cargoDeps;

  strictDeps = true;

  meta = {
    inherit (ringboard-server.meta)
      homepage
      changelog
      license
      platforms
      ;
    description = "CLI for Ringboard, a clipboard manager for Linux";
    mainProgram = "ringboard";
  };
}
