-- guess-indent.nvim
require("guess-indent").setup {}

-- mini.surround
require("mini.surround").setup {
  mappings = {
    suffix_next = "n",
    suffix_last = "N",
  },

  n_lines = 50,

  search_method = "cover_or_next",
}

-- mini.pairs
require("mini.pairs").setup {}

-- mini.icons
require("mini.icons").setup {}

-- mini.statusline
require("mini.statusline").setup {
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 100 }
      local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
      local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
      local filename = MiniStatusline.section_filename { trunc_width = 140 }
      local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      local location = MiniStatusline.section_location { trunc_width = 75 }

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { diagnostics, lsp } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { location } },
      }
    end,
    inactive = nil,
  },
}

-- mini.clue
local miniclue = require("mini.clue")
local function insert_cursor_object_clues()
  local describe = function(prefix)
    local make_clue = function(key, desc)
      return { mode = "c", keys = prefix .. key, desc = desc }
    end
    return {
      make_clue("<C-f>", "Filename under cursor"),
      make_clue("<C-p>", "Filename under cursor, expanded with 'path'"),
      make_clue("<C-w>", "Word under cursor"),
      make_clue("<C-a>", "WORD under cursor"),
      make_clue("<C-l>", "Line under cursor"),
    }
  end

  return {
    describe("<C-r>"),
    describe("<C-r><C-r>"),
    describe("<C-r><C-o>"),
  }
end
miniclue.setup {
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },

    -- Marks
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },

    -- Registers
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    insert_cursor_object_clues(),
  },

  window = {
    delay = 0,
    config = {
      width = 50,
    },
  },
}

require("fidget").setup {
  progress = {
    display = {
      overrides = {
        emmylua_ls = { name = "emmylua-ls" },
      },
    },
  },
  notification = {
    window = {
      winblend = 0,
      max_width = 0.5,
    },
  },
}

require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "nixfmt" },
  },
  default_format_opts = {
    async = true,
  },
  format_after_save = {},
}

require("mini.indentscope").setup {
  draw = {
    delay = 10,
    animation = require("mini.indentscope").gen_animation.none(),
  },
  symbol = "│",
}
local indentscope_augroup = vim.api.nvim_create_augroup("mini.indentscope", {})
vim.api.nvim_create_autocmd("FileType", {
  group = indentscope_augroup,
  pattern = { "help" },
  callback = function(args) vim.b[args.buf].miniindentscope_disable = true end,
})
