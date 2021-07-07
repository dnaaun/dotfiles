local saga = require 'lspsaga'

--use default config
saga.init_lsp_saga {
  code_action_keys = {
   quit = '<Esc>',
   exec = '<CR>'
 },
 code_action_icon = '',
 code_action_prompt = {
   enable = false,
   sign = false,
   sign_priority = 19,
   virtual_text = false,
 },

}



-- show hover doc
vim.api.nvim_set_keymap('n', 'K', ":Lspsaga hover_doc<CR>", { silent=true, noremap=true })

-- scroll down hover doc or scroll in definition preview
vim.api.nvim_set_keymap('n', '<C-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", { silent=true, noremap=true })
vim.api.nvim_set_keymap('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", { silent=true, noremap=true })
vim.api.nvim_set_keymap('n', 'gR', ":Lspsaga rename<CR>", { silent=true, noremap=true })
vim.api.nvim_set_keymap('n', '[e', ":Lspsaga diagnostic_jump_prev<CR>", { silent=true, noremap=true })
vim.api.nvim_set_keymap('n', ']e', ":Lspsaga diagnostic_jump_next<CR>", { silent=true, noremap=true })
vim.api.nvim_set_keymap('n', 'gh', ':Lspsaga show_line_diagnostics<CR>', { silent=true, noremap=true })
vim.api.nvim_set_keymap('n', '<leader>ld', ':Lspsaga preview_definition<CR>', { silent=true, noremap=true })
