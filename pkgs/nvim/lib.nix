lib: {
  sources =
    pkgs: args:
    lib.pipe ./npins [
      (lib.flip import args)
      (lib.mapAttrs (_: spec: spec { inherit pkgs; }))
    ];
}
