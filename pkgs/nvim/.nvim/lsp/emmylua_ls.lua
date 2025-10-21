---@type vim.lsp.ClientConfig
return {
  settings = {
    emmylua = {
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
