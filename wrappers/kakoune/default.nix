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
    in
    assert !(options ? kakrc && options ? kakrcFile);
    inputs.mkWrapper {
      inherit (options) package;
      pname = "kakoune";

      wrapperArgs = "--prefix PATH : ${lib.makeBinPath options.neededBinaries}";

      symlinks = {
        "$out/share/kak/kakrc.local" =
          if options ? kakrc then
            pkgs.writeText "kakrc" options.kakrc
          else if options ? kakrcFile then
            options.kakrcFile
          else
            null;
      };

      preWrap = ''
        ${lib.getExe pkgs.lndir} -silent ${./runtime} $out/share/kak
        cp --remove-destination $(readlink -e "$out/bin/kak") $out/bin/kak
      '';

      environment = {
        KAKOUNE_POSIX_SHELL = lib.getExe pkgs.dash;
      };
    };
}
