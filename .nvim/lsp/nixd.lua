local nixpkgs =
  '(builtins.getFlake "git+file://${toString ./.}").inputs.nixpkgs.legacyPackages.${builtins.currentSystem}'

---@type vim.lsp.ClientConfig
return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = nixpkgs,
      },
      options = {
        nixos = {
          expr = string.format(
            [[
            let
              pkgs = "%s";
              modules = pkgs.lib.evalModules {
                modules = import "${pkgs.path}/nixos/modules/module-list.nix" ++ [{ nixpkgs.hostPlatform = builtins.currentSystem; }];
              };
            in modules.options
            ]],
            nixpkgs
          ),
        },
      },
    },
  },
}
