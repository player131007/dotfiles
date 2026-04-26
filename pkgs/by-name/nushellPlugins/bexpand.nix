{
  lib,
  rustPlatform,
  fetchFromGitea,
  nushell,
}:
rustPlatform.buildRustPackage {
  pname = "nu_plugin_bexpand";
  version = "1.3.11211+nu-0.112.1";

  src = fetchFromGitea {
    domain = "forge.axfive.net";
    owner = "Taylor";
    repo = "nu-plugin-bexpand";
    rev = "aab59283343e2d06d119311abf5e8c028c7579e8";
    hash = "sha256-aO3SL7DO6932nW0kVRtYoWCtzR8fzGAZ5mBdF++GinY=";
  };

  cargoHash = "sha256-cgkgNb2Rb+6568TiREBakuEAdAEUgZUvWIi6N3SVPrM=";

  meta = {
    description = "Bash style brace expansion for nushell";
    mainProgram = "nu_plugin_bexpand";

    broken = lib.versions.majorMinor nushell.version != "0.112";
  };
}
