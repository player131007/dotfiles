{
  programs.ssh = {
    startAgent = true;
    knownHostsFiles = [ ./github_keys ];
  };
}
