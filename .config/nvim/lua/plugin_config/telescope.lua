local trouble = require("trouble.providers.telescope")

require("telescope").setup {
  defaults = {
          generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble }
          },
  },
  pickers = {
  },
   extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
    }
  }
}

require('telescope').load_extension('fzf')


-- Mappings
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').fd()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>ft', "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>f:', "<cmd>lua require('telescope.builtin').command_history()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>f/', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').oldfiles()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fj', "<cmd>lua require('telescope.builtin').jumplist()<CR>", { noremap= true } )
-- LSP related
vim.api.nvim_set_keymap('n', 'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', 'gs', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', 'ga', "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>", { noremap= true } )
