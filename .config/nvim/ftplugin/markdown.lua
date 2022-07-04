local mapfunc = require('std2').mapfunc
local nvim_set_keymap = vim.api.nvim_set_keymap

-- Text iwidth
vim.opt.tw=88

vim.opt.expandtab = true
-- show existing tab with 2 spaces width
vim.opt.tabstop=2
vim.opt.softtabstop=2
-- when indenting with '>', use 2 spaces width
vim.opt.shiftwidth=2

-- Enable spelling
vim.opt.spell = true
---- vim-markdown ----
-- Markdown fenced languages support
-- https://github.com/plasticboy/vim-markdown/commit/04e060dc062ee981f5c9bcc8f3b700f803da285f
vim.g.vim_markdown_fenced_languages = { "json", "bash", "lua" }
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 0
---- Markdown, make preview available remotely (ie, serve on 0.0.0.0, not localhost)
vim.g.mkdp_open_to_the_world = 1
nvim_set_keymap("n", "<Leader>m", "<Plug>MarkdownPreviewToggle<CR>", {})
