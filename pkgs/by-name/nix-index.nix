{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage {
  pname = "nix-index";
  version = "0-unstable-2026-07-03";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "nix-index";
    rev = "f18f838273a5557d849864292520d6b2bb466b93";
    hash = "sha256-iUdcd5R07daVnlkaYvpFBmluAC5v/ARHkcdXlZE3O/E=";
  };

  cargoHash = "sha256-+80ZiC6n/LrGG0+3LTZ4n4yaDYGcOzp1MxrbdFftVI0=";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
    sqlite
  ];

  meta = {
    description = "Files database for nixpkgs";
    license = [ lib.licenses.bsd3 ];
  };
}
