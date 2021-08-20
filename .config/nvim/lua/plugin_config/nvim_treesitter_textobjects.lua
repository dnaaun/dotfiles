-- The text objects below are named after the first letter,
-- except for the following text objects:
--   - conditional - i for if statement
--   - comment - k for "komment"
--   - statement - t for s*t*atement
--   - class - { because [{ takes you to the previous class in vanilla (neo)vim
require'nvim-treesitter.configs'.setup {
  textobjects = {
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
          ["]p"] = "@parameter.outer",

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
          ["[T"] = "@statement.outer",

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
  },
}
