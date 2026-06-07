{
  lib,
  rustPlatform,
  fetchFromGitea,
  nushell,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_bexpand";
  version = "1.3.11300+nu-0.113.0";

  src = fetchFromGitea {
    domain = "forge.axfive.net";
    owner = "Taylor";
    repo = "nu-plugin-bexpand";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mN+54dn/to7JOXL3uCFd0/LmKEz21R3heVG6tGgiapw=";
  };

  cargoHash = "sha256-AxU+aX6DjGsPvcFDonmCE06JrBTeXnybZ8i7Ew79wuU=";

  meta = {
    description = "Bash style brace expansion for nushell";
    mainProgram = "nu_plugin_bexpand";

    broken =
      let
        inherit (lib.versions) majorMinor;

        m = builtins.match "[0-9]+\\.[0-9]+\\.[0-9]+\\+nu-([0-9]+\\.[0-9]+\\.[0-9]+)" finalAttrs.version;
        version = builtins.head m;
      in
      assert m != null;
      majorMinor version != majorMinor nushell.version;
  };
})
