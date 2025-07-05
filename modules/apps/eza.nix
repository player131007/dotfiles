{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.eza ];

      environment.shellAliases =
        let
          eza = "eza --icons -F";
        in
        {
          ls = "${eza}";
          ll = "${eza} -lhb";
          l = "${eza} -lhba";
        };
    };
}
