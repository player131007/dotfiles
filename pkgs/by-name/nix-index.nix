{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
  sqlite,

  util-linux,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "nix-index";
    rev = "82794d152fbeb37b308b69a8ce3520e30c5a55f7";
    hash = "sha256-2QOJbGN6vcPVjszz0vQ2bERWLmWR8owAXjfdCKzibQI=";
  };

  cargoHash = "sha256-QO7Hq96IrFEhXhyVhti4GnicwEz+aoLAwtDOOOO2ctg=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    openssl
    curl
    sqlite
  ];

  postInstall = ''
    wrapProgram $out/bin/command-not-found --prefix PATH : ${util-linux.bin}/bin
  '';

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
