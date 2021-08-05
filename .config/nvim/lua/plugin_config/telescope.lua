local trouble = require("trouble.providers.telescope")

require("telescope").setup {
  defaults = {
          generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
          mappings = {
            i = {
              ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble }
          },
  },
  pickers = {
    buffers = {
      mappings = {
        i =  {
          ["<c-d>"] = "delete_buffer"
        },
        n = {
           ["<c-d>"] = "delete_buffer"
         }
       }
    }
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
require('telescope').load_extension('aerial')


-- Mappings
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').fd()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fcf', "<cmd>lua require('telescope.builtin').fd({search_dirs=vim.fn.expand('%:p:h')})<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fcg', "<cmd>lua require('telescope.builtin').live_grep({search_dirs={vim.fn.expand('%:p:h')}})<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap= true } )
-- Isn't prefixed with f cuz it's so commonly used
vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>lua require('telescope.builtin').buffers()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>ft', "<cmd>lua require('telescope.builtin').help_tags()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>f:', "<cmd>lua require('telescope.builtin').command_history()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>f/', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').oldfiles()<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', '<leader>fj', "<cmd>lua require('telescope.builtin').jumplist()<CR>", { noremap= true } )
-- LSP related
vim.api.nvim_set_keymap('n', 'gd', "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", { noremap= true } )
-- Use Aerial for symbol search because it allows filtering symbol types.
vim.api.nvim_set_keymap('n', 'gs', "<cmd>Telescope aerial<CR>", { noremap= true } )
vim.api.nvim_set_keymap('n', 'ga', "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>", { noremap= true } )
