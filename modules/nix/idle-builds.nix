{
  flake.modules.nixos.pc = {
    nix = {
      daemonCPUSchedPolicy = "idle";
      daemonIOSchedClass = "idle";
    };
  };
}
