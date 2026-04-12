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
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "nix-index";
    rev = "68f39e70075fc795ff7f41ab83e44addc7448743";
    hash = "sha256-zIyuGnpOZpOhWyfcn2cvJjF+Nw1VEWQcnpjTw2ktgIE=";
  };

  cargoHash = "sha256-sgbMy+vCH6EG42u2SfIco6l84auL9R6Sz61GJHF4fUY=";

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
