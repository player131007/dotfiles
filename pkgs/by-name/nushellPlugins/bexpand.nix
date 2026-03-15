{
  lib,
  rustPlatform,
  fetchFromGitea,
  nushell,
}:
rustPlatform.buildRustPackage {
  pname = "nu_plugin_bexpand";
  version = "1.3.11100";

  src = fetchFromGitea {
    domain = "forge.axfive.net";
    owner = "Taylor";
    repo = "nu-plugin-bexpand";
    rev = "5d316cd6620004214c16b41a0912efdc5e6a72db";
    hash = "sha256-3kCXtXGgUTAVu0qc+TjxbWQFaF2yJo2fKWYadH5+/oQ=";
  };

  cargoHash = "sha256-FkOExHoSrEC3d8CTxEAGBFZ4qyXAn4+9xv/iydVO3Uw=";

  meta = {
    description = "Bash style brace expansion for nushell";
    mainProgram = "nu_plugin_bexpand";

    broken = lib.versions.majorMinor nushell.version != "0.111";
  };
}
