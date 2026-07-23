{ types, ... }: {
  inputs = {
    nixpkgs.from = { parent }: parent.nixpkgs;
    self.from = { parent }: parent.self;
  };

  options = {
    nix-index-cache.type = types.derivation;
  };

  mutations =
    let
      wrap =
        f:
        let
          result =
            { options, inputs }:
            let
              command-not-found = inputs.nixpkgs.lib.getExe' (options { }) "command-not-found";
            in
            f command-not-found;
        in
        result;
    in
    {
      "/bash".interactiveShellInit = wrap (command-not-found: /* bash */ ''
        command_not_found_handle() {
          ${command-not-found} "$1"
        }
      '');

      "/fish".interactiveShellInit = wrap (command-not-found: /* fish */ ''
        function fish_command_not_found
          ${command-not-found} $argv[1]
        end
      '');

      "/nushell".shellInit = wrap (command-not-found: /* nu */ ''
        $env.config.hooks.command_not_found = [
          {|cmd| ${command-not-found} $cmd | print }
        ]
      '');
    };

  impl =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs lib;
      inherit (inputs.self.pkgs) nix-index;

      nix-index-db = pkgs.callPackage ./db.nix {
        inherit nix-index;
        inherit (options) nix-index-cache;
      };

      nix-index-db-bin-only = nix-index-db.override {
        name = "nix-index-db-bin-only";
        extraArgs = lib.escapeShellArgs [
          "--filter-prefix=/bin/"
          "--compression=9"
        ];
      };
    in
    pkgs.symlinkJoin {
      pname = "nix-index-wrapped";
      inherit (nix-index) version;

      paths = [ nix-index ];
      nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
      postBuild = ''
        wrapProgram $out/bin/nix-locate \
          --inherit-argv0 \
          --set-default NIX_INDEX_DATABASE ${nix-index-db}

        wrapProgram $out/bin/command-not-found \
          --inherit-argv0 \
          --suffix PATH : ${pkgs.util-linux.bin}/bin \
          --set-default NIX_INDEX_DATABASE ${nix-index-db-bin-only}
      '';
    };
}
