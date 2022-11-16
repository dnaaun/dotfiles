vim.opt_local.formatoptions = {}
vim.opt_local.wrap = false

-- Set omnifunc
-- vim.opt_local.omnifunc=ale#completion#OmniFunc

vim.opt_local.expandtab = true
-- show existing tab with 2 spaces width
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
-- when indenting with '>', use 2 spaces width
vim.opt_local.shiftwidth = 4

-- https://github.com/thedodd/trunk/issues/331
vim.opt_local.backupcopy = "no"

-- Continue comments on next line
vim.opt_local.formatoptions:append("cro")
