-- Various Treesitter modules config

local highlight = {
  enable = true
}
local indent = {
  enable = true
}
-- requires https://github.com/nvim-treesitter/nvim-treesitter-refactor
local refactor = {
  highlight_definitions = { enable = true },
  --highlight_current_scope = { enable = true },
}
-- requires https://github.com/nvim-treesitter/nvim-treesitter-textobjects ( or some
-- link like that)
local textobjects = {
  select = {
    enable = true,
    keymaps = {
      -- You can use the capture groups defined in textobjects.scm
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["a{"] = "@class.outer",
      ["i{"] = "@class.inner",
      ["ak"] = "@comment.outer",
      ["ib"] = "@block.inner",
      ["ab"] = "@block.outer",
      ["ic"] = "@call.inner",
      ["ac"] = "@call.outer",
      ["ii"] = "@conditional.inner", -- i for *i*f statement
      ["ai"] = "@conditional.outer",
      ["il"] = "@loop.inner",
      ["al"] = "@loop.outer",
      ["ip"] = "@parameter.inner",
      ["ap"] = "@parameter.outer",
      ["is"] = "@scopename.inner",
      ["at"] = "@statement.outer"
    },
  },
  move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]{"] = "@class.outer",
        ["]k"] = "@comment.outer",
        ["]b"] = "@block.outer",
        ["]c"] = "@call.outer",
        ["]i"] = "@conditional.outer",
        ["]l"] = "@loop.outer",
        ["]p"] = "@parameter.outer"

      },
      goto_next_end = { -- Note that @class.outer is missing
        ["[F"] = "@function.outer",
        ["]}"] = "@class.outer",
        ["[K"] = "@comment.outer",
        ["[B"] = "@block.outer",
        ["[C"] = "@call.outer",
        ["[I"] = "@conditional.outer",
        ["[L"] = "@loop.outer",
        ["[P"] = "@parameter.outer",
        ["[T"] = "@statement.outer"

      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[{"] = "@class.outer",
        ["[k"] = "@comment.outer",
        ["[b"] = "@block.outer",
        ["[c"] = "@call.outer",
        ["[i"] = "@conditional.outer",
        ["[l"] = "@loop.outer",
        ["[p"] = "@parameter.outer",
        ["[t"] = "@statement.outer",
      },
      goto_previous_end = {-- Note that @class.outer is missing
        ["[F"] = "@function.outer",
        ["[}"] = "@class.outer",
        ["[K"] = "@comment.outer",
        ["[B"] = "@block.outer",
        ["[C"] = "@call.outer",
        ["[I"] = "@conditional.outer",
        ["[L"] = "@loop.outer",
        ["[P"] = "@parameter.outer",
        ["[T"] = "@statement.outer",
      },
    },
    lsp_interop = {
    enable = true,
    border = 'none',
    peek_definition_code = {
      ["<leader>ld"] = "@function.outer",
      ["<leader>lD"] = "@class.outer",
    },
  },
}

local autotag = {
  enable = true,
  filetypes = { 'html', 'htmldjango', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue'}

}


require'nvim-treesitter.configs'.setup {
    highlight = highlight,
    indent = indent,
    refactor = refactor,
    textobjects = textobjects,
    autotag = autotag
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "jsx", "javascript.jsx", "javascriptreact" }
