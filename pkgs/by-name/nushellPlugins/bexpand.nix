{
  lib,
  rustPlatform,
  fetchFromGitea,
  nushell,
}:
rustPlatform.buildRustPackage {
  pname = "nu_plugin_bexpand";
  version = "1.3.11000";

  src = fetchFromGitea {
    domain = "forge.axfive.net";
    owner = "Taylor";
    repo = "nu-plugin-bexpand";
    rev = "9e7c615d84d5da8f8cd01887a59266c48434e516";
    hash = "sha256-1NO4onzK3MIX98CnsecRvWtilTW1LjXv3mi11Aqbrjg=";
  };

  cargoHash = "sha256-uOPOSOQJMN3D96ve8iuMPzs89GEAe9cCpu7zFcXTRSw=";

  meta = {
    description = "Bash style brace expansion for nushell";
    mainProgram = "nu_plugin_bexpand";

    broken = lib.versions.majorMinor nushell.version != "0.110";
  };
}
