{
  lib,
  fetchFromGitHub,
  rustPlatform_nightly,

  ringboard-cli,
  ringboard-tui,
  ringboard-x11,
  ringboard-wayland,
  ringboard-egui,

  systemdSupport ? true,
}:
rustPlatform_nightly.buildRustPackage (finalAttrs: {
  pname = "ringboard-server";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "clipboard-history";
    tag = finalAttrs.version;
    hash = "sha256-e5cZQ0j4gvXlbLCHc6dUVStWzih9HbDAtnSW7v+PKCk=";
  };

  buildAndTestSubdir = "server";
  cargoDeps = rustPlatform_nightly.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "ringboard-${finalAttrs.version}";
    hash = "sha256-+E6BzfgUvpBZzkzvPvFfEt/IoVR/wU4uHECs4Dn5pIE=";  
  };

  strictDeps = true;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "human-logs"
  ] ++ (lib.optional systemdSupport "systemd");

  passthru = {
    inherit
      ringboard-cli
      ringboard-tui
      ringboard-x11
      ringboard-wayland
      ringboard-egui
      ;
  };

  meta = {
    description = "Server component for Ringboard, a clipboard manager for Linux";
    homepage = "https://github.com/SUPERCILEX/clipboard-history";
    changelog = "https://github.com/SUPERCILEX/clipboard-history/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "ringboard-server";
  };
})
