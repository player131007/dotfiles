{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.inter
    pkgs.iosevka
  ];

  my.hjem = {
    packages = [ pkgs.qutebrowser ];
    xdg.config.files."qutebrowser/config.py" = {
      type = "copy";
      permissions = "600";
      clobber = true;
      text = /* python */ ''
        config.load_autoconfig()

        c.fonts.tabs.selected = "500 12pt Inter Display"
        c.fonts.tabs.unselected = "500 12pt Inter Display"
        c.fonts.statusbar = "400 10.5pt Iosevka"
        c.fonts.completion.category = "bold 11pt Iosevka"
        c.fonts.completion.entry = "400 10.5pt Iosevka"

        c.completion.quick = False
        c.session.lazy_restore = True
        c.tabs.background = True

        c.editor.command = [ "foot", "--", "nvim", "{file}", "+call cursor({line}, {column})" ]

        config.bind('J', 'tab-prev')
        config.bind('K', 'tab-next')
        config.bind('gJ', 'tab-move -')
        config.bind('gK', 'tab-move +')
        config.bind(',t', 'open -t')
        config.bind(',d', 'config-cycle -p -t -u {url} colors.webpage.darkmode.enabled false true ;; reload')
        config.bind(',r', 'open https://farside.link/{url}')

        c.window.transparent = True

        c.completion.web_history.exclude = [
            "www.messenger.com/*/*",
            "discord.com/channels/*/*",
            "hustack.soict.ai",
        ]

        c.tabs.padding = {
            'top': 7,
            'bottom': 7,
            'left': 9,
            'right': 9
        }

        c.statusbar.padding = {
            'top': 6,
            'bottom': 5,
            'left': 1,
            'right': 1
        }

        c.colors.webpage.preferred_color_scheme = 'dark'
        c.colors.webpage.darkmode.enabled = True
        c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
        c.colors.webpage.darkmode.policy.images = 'never'
        config.set('colors.webpage.darkmode.enabled', False, 'file://*')

        c.url.default_page = "about:blank"
        c.url.start_pages = "about:blank"
        c.url.searchengines = {
            'DEFAULT': 'https://duckduckgo.com/?q={}',
            '!pkg': 'https://search.nixos.org/packages?channel=unstable&query={}',
            '!opt': 'https://search.nixos.org/options?channel=unstable&query={}'
        }

        c.content.blocking.enabled = True
        c.content.blocking.method = "both"
        c.content.blocking.adblock.lists = [
            "https://easylist.to/easylist/easylist.txt",
            "https://easylist.to/easylist/easyprivacy.txt",
            "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
            "https://github.com/uBlockOrigin/uAssets/raw/refs/heads/master/filters/lan-block.txt",
            "https://github.com/uBlockOrigin/uAssets/raw/refs/heads/master/filters/resource-abuse.txt",
            "https://github.com/uBlockOrigin/uAssets/raw/refs/heads/master/filters/filters.txt"
        ]

        c.content.autoplay = False
        c.content.fullscreen.overlay_timeout = 0
        c.tabs.title.format = "{audio}{current_title}"
      '';
    };
  };
}
