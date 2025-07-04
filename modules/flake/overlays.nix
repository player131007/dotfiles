{ fromRoot, ... }:
{
  flake.overlays = {
    _7zz-maybe-unfree = import (fromRoot "overlays/_7zz.nix");
  };
}
