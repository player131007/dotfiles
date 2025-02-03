_: prev: {
    looking-glass-client = prev.looking-glass-client.overrideAttrs (prevAttrs: {
        postPatch = prevAttrs.postPatch or "" + ''
            sed -i 's/"-Wfatal-errors"//g' CMakeLists.txt
        '';
    });
}
