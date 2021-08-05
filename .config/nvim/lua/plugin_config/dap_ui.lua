require("dapui").setup()

vim.api.nvim_set_keymap('n', '<leader>de', '<cmd>lua require("dapui").eval()<CR>', {})
vim.api.nvim_set_keymap('v', '<leader>de', '<cmd>lua require("dapui").eval()<CR>', {})

