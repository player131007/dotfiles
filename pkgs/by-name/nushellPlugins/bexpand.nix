{
  lib,
  rustPlatform,
  fetchFromGitea,
  nushell,
}:
rustPlatform.buildRustPackage {
  pname = "nu_plugin_bexpand";
  version = "1.3.10900";

  src = fetchFromGitea {
    domain = "forge.axfive.net";
    owner = "Taylor";
    repo = "nu-plugin-bexpand";
    rev = "07111c423a1a5e013eb108253068ee36dfcbbfbb";
    hash = "sha256-PWwE+blEc4/LppIyyF4V6t4GmwJgpyWHgnPXVzwfAm0=";
  };

  cargoHash = "sha256-2e6RpSzhcVLyIonICoNXxk1I5rtvEVJRKKyW/rua9/o=";

  meta = {
    description = "Bash style brace expansion for nushell";
    mainProgram = "nu_plugin_bexpand";

    broken = lib.versions.majorMinor nushell.version != "0.109";
  };
}
