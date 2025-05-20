{ ... }:
final: prev: {
  _7zz = prev._7zz.override { enableUnfree = final.config.allowUnfree; };
}
