{ types, ... }: {
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    kakrc.type = types.string;
    kakrcFile = {
      type = types.pathLike;
      default = toString ./kakrc; # FIXME: impure stuff of doom and despair
    };

    neededBinaries = {
      type = types.listOf types.derivation;
      defaultFunc =
        { inputs }:
        let
          inherit (inputs.nixpkgs) pkgs;
        in
        [
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

      wrapperArgs = "--prefix PATH : ${KAKOUNE_RUNTIME}/bin";

      preWrap = /* bash */ ''
        mkdir -p ${KAKOUNE_RUNTIME}/bin
        for i in ${toString (map lib.escapeShellArg options.neededBinaries)}; do
          ${lib.getExe pkgs.lndir} -silent "$i/bin" ${KAKOUNE_RUNTIME}/bin
        done
      '';

      symlinks = {
        "${KAKOUNE_RUNTIME}/kakrc.local" =
          if options ? kakrc then
            pkgs.writeText "kakrc" options.kakrc
          else if options ? kakrcFile then
            options.kakrcFile
          else
            null;
      }
      // (
        ./runtime
        |> lib.filesystem.listFilesRecursive
        |> map (file: {
          name = "${KAKOUNE_RUNTIME}/${lib.path.removePrefix ./runtime file}";
          value = toString file; # FIXME: impure stuff of doom and despair
        })
        |> builtins.listToAttrs
      );

      environment = {
        # location of kak binary is used to find ../share/kak/autoload,
        # unless explicitly overriden with KAKOUNE_RUNTIME
        inherit KAKOUNE_RUNTIME;

        KAKOUNE_POSIX_SHELL = lib.getExe pkgs.dash;
      };
    };
}
