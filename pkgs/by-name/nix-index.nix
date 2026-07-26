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
  version = "0-unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "nix-index";
    rev = "f8e974c19ed22bc27971811872f0e6fc8962e14e";
    hash = "sha256-0edLDfOi7sMy9CrednMCkYcVe1otzediyVaAUUL3xMc=";
  };

  cargoHash = "sha256-aPHy/pb0kS60d/H7yxRf6T9RBWjaJYEmT2DwqBwsOKM=";

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
