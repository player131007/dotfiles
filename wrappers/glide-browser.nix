{ types, ... }: {
  inputs = {
    nixpkgs.from = { parent }: parent.nixpkgs;
    self.from = { parent }: parent.self;
  };

  options = {
    package = {
      type = types.derivation;
      defaultFunc = { inputs }: inputs.self.pkgs.glide-browser-bin-unwrapped;
    };
  };

  impl =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs;
    in
    # the actual firefox version that glide is based on
    # there are version checks inside pkgs.wrapFirefox
    pkgs.wrapFirefox (options.package // { version = "153.0b5"; }) {
      inherit (options.package) version;
    };
}
