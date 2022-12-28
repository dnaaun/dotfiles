local o = vim.opt
local g = vim.g

-- Text iwidth
o.tw = 88

o.expandtab = true
-- show existing tab with 2 spaces width
o.tabstop = 2
o.softtabstop = 2
-- when indenting with '>', use 2 spaces width
o.shiftwidth = 2

-- Enable spelling
o.spell = true
---- vim-markdown ----
-- Markdown fenced languages support
-- https://github.com/plasticboy/vim-markdown/commit/04e060dc062ee981f5c9bcc8f3b700f803da285f
g.vim_markdown_fenced_languages = { "json", "bash", "lua" }
g.vim_markdown_folding_disabled = 1
g.vim_markdown_conceal = 0
---- Markdown, make preview available remotely (ie, serve on 0.0.0.0, not localhost)
g.mkdp_open_to_the_world = 1

local original_timeoutlen = vim.o.timeoutlen

vim.keymap.set("i", "<C-a>", function()
	local amharic_is_on = require("amharic").toggle_amharic()
	if amharic_is_on and vim.o.timeoutlen < 2000 then
		vim.o.timeoutlen = 2000
	elseif not amharic_is_on then
		vim.o.timeoutlen = original_timeoutlen
	end
end, { buffer = true })
