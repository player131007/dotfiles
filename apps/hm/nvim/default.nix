{ config, ... }: {
    xdg.configFile."nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "/home/player131007/apps/hm/nvim/lazy-lock.json";
    xdg.configFile."nvim/init.lua".source = ./init.lua;
    xdg.configFile."nvim/lua" = {
        source = ./lua;
        recursive = true;
    };
    xdg.configFile."nvim/lua/plugins-config/base16.lua".source = config.scheme {
        template = ./colors.mustache;
        extension = ".lua";
    };
}
