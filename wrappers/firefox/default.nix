_: {
  options = {
    # This is technically unfree (see
    # https://github.com/NixOS/nixpkgs/pull/385857), but it makes eval times a
    # lot faster, since normal firefox-unwrapped requires a huge closure, like
    # an entire wasm crosschain.
    package.defaultFunc = { inputs }: inputs.nixpkgs.pkgs.firefox-bin-unwrapped;

    policiesFiles.default = [
      ./policies/extensions.json
      ./policies/policies.json
      ./policies/search_engines.json
    ];

    autoConfigFiles.default = [
      ./prefs/betterfox.js
      ./prefs/smooth_scrolling.js
      ./prefs/prefs.js
    ];
  };
}
