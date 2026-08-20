glide.keymaps.del("normal", "<C-j>");
glide.keymaps.del("normal", "<C-k>");

glide.keymaps.set(["normal", "insert"], "<A-j>", "tab_prev");
glide.keymaps.set(["normal", "insert"], "<A-k>", "tab_next");

// override / key so that it's not swallowed by websites
glide.keymaps.set(
    "normal",
    "/",
    async () => {
        await glide.findbar.open({
            mode: "typeahead",
            query: "",
        });
    },
    { description: "Open quick find bar" },
);
glide.keymaps.set(
    "normal",
    "n",
    async () => {
        await glide.keys.send("<F3>");
    },
    { description: "Jump to next match" },
);
glide.keymaps.set(
    "normal",
    "N",
    async () => {
        await glide.keys.send("<S-F3>");
    },
    { description: "Jump to previous match" },
);

glide.keymaps.set(
    "normal",
    "pp",
    async () => {
        const url = await navigator.clipboard.readText();
        await browser.tabs.update({ url });
    },
    { description: "Open clipboard" },
);

glide.keymaps.set(
    "normal",
    "Pp",
    async () => {
        const url = await navigator.clipboard.readText();
        await browser.tabs.create({ url });
    },
    { description: "Open clipboard in new tab" },
);
