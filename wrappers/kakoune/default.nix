{ promise, types, ... }: {
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
    self.from = { parent }: parent.self;
  };

  options = {
    kakrc.type = types.string;
    kakrcFile = {
      type = types.pathLike;
      default = ./kakrc;
    };

    neededBinaries = {
      type = types.listOf types.derivation;
      default = promise (
        { inputs }:
        let
          inherit (inputs.nixpkgs) pkgs;
        in
        [
          pkgs.util-linux
          pkgs.coreutils
          pkgs.findutils
          pkgs.gnused

          pkgs.jq
          pkgs.kakoune-lsp
          inputs.self.pkgs.kak-guess-indent
        ]
      );
    };

    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.kakoune-unwrapped);
    };
  };

  assertions = [
    {
      verify = { options }: !(options ? kakrc && options ? kakrcFile);
      explain = { }: "'options.kakrc' and 'options.kakrcFile' are mutually exclusive";
    }
  ];

  result = promise (
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs lib;
    in
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
    }
  );
}
