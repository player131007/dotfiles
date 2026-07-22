_adios: {
  options = {
    configFile.default = builtins.toFile "lesskey" ''
      #command
      h left-scroll
      l right-scroll

      #line-edit
      \e abort

      #env
      LESS = --RAW-CONTROL-CHARS --wordwrap --incsearch --search-options=R
    '';
  };
}
