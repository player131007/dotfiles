{ wrappers, ... }:
{
  environment.pathsToLink = [ "/share/nushell" ];
  my.user.packages = [ wrappers.nushell ];
}
