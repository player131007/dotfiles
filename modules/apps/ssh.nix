{
  flake.modules.nixos.pc = {
    programs.ssh.startAgent = true;
  };
}
