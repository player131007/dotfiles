{ ... }: components: toString (builtins.foldl' (path: comp: path + "/${comp}") /. components)
