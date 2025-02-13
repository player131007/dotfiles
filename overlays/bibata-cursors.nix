_: prev: {
  bibata-cursors = prev.bibata-cursors.overrideAttrs {
    buildPhase = ''
      runHook preBuild
      ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Classic -n 'Bibata-Modern-Classic' -c 'Black and rounded edge Bibata cursors.'
      runHook postBuild
    '';
  };
}
