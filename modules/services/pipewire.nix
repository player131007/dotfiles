{
  flake.modules.nixos.pc = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      wireplumber.extraConfig = {
        no-restore-props = {
          "wireplumber.settings" = {
            "node.stream.restore-props" = false;
          };
        };
      };
    };
  };

  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      programs.obs-studio.plugins = [ pkgs.obs-studio-plugins.obs-pipewire-audio-capture ];
    };
}
