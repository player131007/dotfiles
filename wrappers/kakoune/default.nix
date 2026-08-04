{ types, ... }: {
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    kakrc.type = types.string;
    kakrcFile = {
      type = types.pathLike;
      default = ./kakrc;
    };

    neededBinaries = {
      type = types.listOf types.derivation;
      defaultFunc =
        { inputs }:
        let
          inherit (inputs.nixpkgs) pkgs;
        in
        [
          pkgs.util-linux
          pkgs.xdg-utils
          pkgs.coreutils
          pkgs.findutils
          pkgs.gnused
          pkgs.kakoune-lsp
        ];
    };

    package = {
      type = types.derivation;
      defaultFunc = { inputs }: inputs.nixpkgs.pkgs.kakoune-unwrapped;
    };
  };

  impl =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs lib;

      KAKOUNE_RUNTIME = "$out/share/kak";
    in
    assert !(options ? kakrc && options ? kakrcFile);
    inputs.mkWrapper {
      inherit (options) package;
      pname = "kakoune";

      wrapperArgs = "--prefix PATH : ${lib.makeBinPath options.neededBinaries}";

      symlinks = {
        "${KAKOUNE_RUNTIME}/kakrc.local" =
          if options ? kakrc then
            pkgs.writeText "kakrc" options.kakrc
          else if options ? kakrcFile then
            options.kakrcFile
          else
            null;
      };

      preWrap = "
        ${lib.getExe pkgs.lndir} -silent ${./runtime} ${KAKOUNE_RUNTIME}
      ";

      environment = {
        # location of kak binary is used to find ../share/kak/autoload,
        # unless explicitly overriden with KAKOUNE_RUNTIME
        inherit KAKOUNE_RUNTIME;

        KAKOUNE_POSIX_SHELL = lib.getExe pkgs.dash;
      };
    };
}
