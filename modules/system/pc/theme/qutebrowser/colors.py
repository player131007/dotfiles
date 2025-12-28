# theme section
#
c.colors.webpage.darkmode.enabled = True
config.set('colors.webpage.darkmode.enabled', False, 'file://*')
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.colors.webpage.darkmode.policy.images = 'smart-simple'

c.colors.webpage.preferred_color_scheme = 'dark'

palette = {
    "Base": "#191724",
    "Surface": "#1f1d2e",
    "Overlay": "#26233a",
    "Muted": "#6e6a86",
    "Subtle": "#908caa",
    "Text": "#e0def4",
    "Love": "#eb6f92",
    "Gold": "#f6c177",
    "Rose": "#ebbcba",
    "Pine": "#31748f",
    "Foam": "#9ccfd8",
    "Iris": "#c4a7e7",
    "HighlightLow": "#21202e",
    "HighlightMed": "#403d52",
    "HighlightHigh": "#524f67",
}

c.colors.completion.category.bg = palette["Base"]
c.colors.completion.category.border.bottom = palette["Surface"]
c.colors.completion.category.border.top = palette["Overlay"]
c.colors.completion.category.fg = palette["Love"]
c.colors.completion.even.bg = palette["HighlightLow"]
c.colors.completion.odd.bg = palette["HighlightLow"]
c.colors.completion.fg = palette["Text"]

c.colors.completion.item.selected.bg = palette["HighlightMed"]
c.colors.completion.item.selected.border.bottom = palette["Surface"]
c.colors.completion.item.selected.border.top = palette["Surface"]
c.colors.completion.item.selected.fg = palette["Text"]
c.colors.completion.item.selected.match.fg = palette["Rose"]
c.colors.completion.match.fg = palette["Rose"]

c.colors.completion.scrollbar.bg = palette["Overlay"]
c.colors.completion.scrollbar.fg = palette["Surface"]

c.colors.statusbar.normal.bg = palette["Base"]
c.colors.statusbar.insert.bg = palette["Base"]
c.colors.statusbar.command.bg = palette["Base"]
c.colors.statusbar.command.private.bg = palette["Base"]
c.colors.statusbar.caret.bg = palette["Base"]
c.colors.statusbar.caret.selection.bg = palette["Base"]
c.colors.statusbar.passthrough.bg = palette["Surface"]
c.colors.statusbar.private.bg = palette["Love"]

c.colors.statusbar.progress.bg = palette["Foam"]

c.colors.statusbar.normal.fg = palette["Rose"]
c.colors.statusbar.insert.fg = palette["Pine"]
c.colors.statusbar.command.fg = palette["Love"]
c.colors.statusbar.passthrough.fg = palette["Subtle"]
c.colors.statusbar.caret.fg = palette["Overlay"]
c.colors.statusbar.caret.selection.fg = palette["Iris"]
c.colors.statusbar.private.fg = palette["HighlightMed"]
c.colors.statusbar.command.private.fg = palette["Love"]

c.colors.statusbar.url.error.fg = palette["Gold"]

c.colors.statusbar.url.fg = palette["Text"]

c.colors.statusbar.url.hover.fg = palette["Gold"]

c.colors.statusbar.url.success.http.fg = palette["Subtle"]

c.colors.statusbar.url.success.https.fg = palette["Subtle"]

c.colors.statusbar.url.warn.fg = palette["Gold"]

c.colors.tabs.bar.bg = palette["Base"]
c.colors.tabs.even.bg = palette["Base"]
c.colors.tabs.odd.bg = palette["Base"]

c.colors.tabs.even.fg = palette["Subtle"]
c.colors.tabs.odd.fg = palette["Subtle"]

c.colors.tabs.selected.even.bg = palette["HighlightMed"]
c.colors.tabs.selected.odd.bg = palette["HighlightMed"]

c.colors.tabs.selected.even.fg = palette["Text"]
c.colors.tabs.selected.odd.fg = palette["Text"]

c.colors.tabs.indicator.error = palette["Gold"]
c.colors.tabs.indicator.start = palette["Pine"]
c.colors.tabs.indicator.stop = palette["Rose"]
c.colors.tabs.indicator.system = "hsv"
c.colors.tabs.pinned.even.fg = palette["Subtle"]
c.colors.tabs.pinned.even.bg = palette["Overlay"]
c.colors.tabs.pinned.odd.fg = palette["Subtle"]
c.colors.tabs.pinned.odd.bg = palette["Overlay"]
c.colors.tabs.pinned.selected.even.fg = palette["Text"]
c.colors.tabs.pinned.selected.even.bg = palette["HighlightMed"]
c.colors.tabs.pinned.selected.odd.fg = palette["Text"]
c.colors.tabs.pinned.selected.odd.bg = palette["HighlightMed"]

c.colors.webpage.bg = palette["Base"]
c.colors.contextmenu.menu.bg = palette["Base"]
c.colors.contextmenu.menu.fg = palette["Text"]

c.colors.contextmenu.disabled.bg = palette["Surface"]
c.colors.contextmenu.disabled.fg = palette["Text"]

c.colors.contextmenu.selected.bg = palette["Rose"]
c.colors.contextmenu.selected.fg = palette["Base"]

c.colors.keyhint.bg = palette["Surface"]

c.colors.keyhint.fg = palette["Text"]

c.colors.keyhint.suffix.fg = palette["Rose"]

c.colors.hints.bg = palette["Surface"]

c.colors.hints.fg = palette["Text"]

c.colors.hints.match.fg = palette["Rose"]

c.colors.downloads.bar.bg = palette["Base"]
c.colors.downloads.error.bg = palette["Base"]
c.colors.downloads.start.bg = palette["Base"]
c.colors.downloads.stop.bg = palette["Base"]

c.colors.downloads.error.fg = palette["Gold"]
c.colors.downloads.start.fg = palette["Pine"]
c.colors.downloads.stop.fg = palette["Rose"]
c.colors.downloads.system.fg = "none"
c.colors.downloads.system.bg = "none"

c.colors.prompts.bg = palette["Surface"]
c.colors.prompts.border = palette["Subtle"]
c.colors.prompts.fg = palette["Text"]
c.colors.prompts.selected.bg = palette["Overlay"]
c.colors.prompts.selected.fg = palette["Text"]

c.colors.messages.error.bg = palette["Surface"]
c.colors.messages.error.border = palette["Surface"]
c.colors.messages.error.fg = palette["Text"]

c.colors.messages.info.bg = palette["Surface"]
c.colors.messages.info.border = palette["Surface"]
c.colors.messages.info.fg = palette["Gold"]

c.colors.messages.warning.bg = palette["Surface"]
c.colors.messages.warning.border = palette["Surface"]
c.colors.messages.warning.fg = palette["Gold"]

c.colors.tooltip.bg = palette["Overlay"]
c.colors.tooltip.fg = palette["Text"]
