{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage {
  pname = "nix-index-unwrapped";
  version = "0-unstable-2026-06-06";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "nix-index";
    rev = "dd81c25fd8fe17e27169688251efc1bb980d1971";
    hash = "sha256-H1bIRWSKAgp4zC0A7z/wMf4TNhopr8nBBSPVFujJxFo=";
  };

  cargoHash = "sha256-FSKXmFaAR6aKkKvpftiH1FBaYTHX6M4MDumZ3Qyavro=";

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
