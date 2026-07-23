{ types, ... }: {
  options = {
    pkgs.type = types.attrs;
    lib.type = types.attrs;
  };
}
