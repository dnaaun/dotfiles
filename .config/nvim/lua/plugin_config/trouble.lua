 require("trouble").setup {
     action_keys = {
         -- By default <cr> jumps without closing the preview window. We don't want that.
         jump_close = { "<cr>" },
         jump = { "<tab>" }
     }
}

vim.api.nvim_set_keymap("n", "gr", "<cmd>Trouble lsp_references<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>ex", "<cmd>Trouble<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>ew", "<cmd>Trouble lsp_workspace_diagnostics<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "ge", "<cmd>Trouble lsp_document_diagnostics<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>el", "<cmd>Trouble loclist<cr>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("n", "<leader>eq", "<cmd>Trouble quickfix<cr>", {silent = true, noremap = true})
