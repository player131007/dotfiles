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
    rev = "d402549f7302cbd0a067016c843876bc7ccb1a74";
    hash = "sha256-hzzmnTRFE1CmIJwM+mIbaM8aCqSXxtonkvwmyZQ5tFw=";
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
