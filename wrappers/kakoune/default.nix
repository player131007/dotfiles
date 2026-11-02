{
  assertions,
  promise,
  types,
  ...
}:
let
  minimalBin = pkgs: [
    # needed for kakoune std runtime
    pkgs.util-linux # setsid
    pkgs.coreutils
    pkgs.findutils
    pkgs.gnused
  ];
in
{
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

    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.kakoune-unwrapped);
    };

    extraBinPaths = {
      type = types.listOf types.derivation;
      default = promise (
        { inputs }:
        let
          inherit (inputs.nixpkgs) pkgs;
        in
        minimalBin pkgs
        ++ [
          pkgs.jq
          pkgs.kakoune-lsp
          inputs.self.pkgs.kak-guess-indent
        ]
      );
    };

    extraRuntime = {
      type = types.listOf types.pathLike;
      default = [
        # small trick to copy the contents of directory and not the directory itself
        "${./runtime}/."
      ];
    };
  };

  assertions = [
    (assertions.disjoint "kakrc" "kakrcFile")
  ];

  inputs.mkWrapper.options = promise (
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs lib;
    in
    {
      inherit (options) package;
      pname = "kakoune";

      wrapperArgs = "--prefix PATH : ${lib.makeBinPath options.extraBinPaths}";

      symlinks = {
        "$out/share/kak/kakrc.local" =
          if options ? kakrc then
            pkgs.writeText "kakrc" options.kakrc
          else if options ? kakrcFile then
            options.kakrcFile
          else
            null;
      };

      preWrap = lib.optionalString (options.extraRuntime != [ ]) ''
        cp -rf ${lib.escapeShellArgs options.extraRuntime} $out/share/kak
      '';

      environment = {
        KAKOUNE_POSIX_SHELL = lib.getExe pkgs.dash;
        KAKOUNE_RUNTIME = "$out/share/kak";
      };
    }
  );

  result = promise ({ results }: results.mkWrapper);

  modules.minimal = {
    inputs.nixpkgs.from = { root }: root.nixpkgs;
    inputs.self.from = { root }: root.self;
    inputs.kakoune = {
      from = { parent }: parent;
      options = promise (
        { inputs }:
        let
          inherit (inputs.nixpkgs) pkgs lib;
          inherit (lib.fileset) unions toSource;
        in
        {
          extraBinPaths = minimalBin pkgs ++ [ inputs.self.pkgs.kak-guess-indent ];
          extraRuntime =
            let
              runtime-minimal = toSource {
                root = ./runtime;
                fileset = unions [
                  ./runtime/autoload/config/guess-indent.kak
                  ./runtime/autoload/config/smarttab.kak
                  ./runtime/autoload/filetype
                ];
              };
            in
            [ "${runtime-minimal}/." ];
        }
      );
    };
    result = promise ({ results }: results.kakoune);
  };
}
