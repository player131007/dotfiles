---@diagnostic disable-next-line: missing-fields
---@type vim.lsp.ClientConfig
return {
  settings = {
    emmylua = {
      diagnostics = {
        disable = { "redefined-local" },
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
