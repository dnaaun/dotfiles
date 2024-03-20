local o = vim.opt
local g = vim.g

o.textwidth = 0

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

vim.keymap.set("i", "<C-a>", function()
	local amharic_is_on = require("amharic").toggle_amharic()
	if amharic_is_on and vim.o.timeoutlen < 2000 then
		vim.o.timeoutlen = 2000
	elseif not amharic_is_on then
		vim.o.timeoutlen = original_timeoutlen
	end
end, { buffer = true })

vim.keymap.set("n", "<CR>", ":<C-u>GpChatRespond<CR>", { buffer = true, desc = "send to GPT (gp.nvim)" })
