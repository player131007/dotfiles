{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        inter
      ];
    };
}
