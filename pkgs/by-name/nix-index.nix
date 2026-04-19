{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,

  util-linux,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0-unstable-2026-04-19";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "nix-index";
    rev = "8c60306353f4050457f49940056c7bbcde969357";
    hash = "sha256-9NFYGBCQSc16nM6wT3BAKd/dvgTPCbqSItNbxPa2wEA=";
  };

  cargoHash = "sha256-JqpHpCrGWAdb4YnebeR1FFrlTArayh+MnJdHkrgo6Gw=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    openssl
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
