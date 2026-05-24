{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index-unwrapped";
  version = "0-unstable-2026-05-24";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "nix-index";
    rev = "79602430c8d2f0a6cfe8e6cba6180a57bdb34cc2";
    hash = "sha256-5fnCFCibKlpIXWvej02x0qsxHckhD1XbNhdhq2zTQGQ=";
  };

  cargoHash = "sha256-kDHVdCKUdjdxyT5CvoOyZSD25JvB9EnF2rypvbvBTQg=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
    sqlite
  ];

  meta = with lib; {
    description = "Files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [
      bennofs
      ncfavier
    ];
  };
}
