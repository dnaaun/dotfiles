local o = vim.opt
local g = vim.g

o.textwidth = 0

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

-- Setup otter.nvim
-- require("otter").activate(nil, true, true, nil)

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.md",
	callback = function()
		if string.match(vim.fn.expand("%:p"), "/gp/chats") then
			vim.keymap.set("n", "<CR>", ":<C-u>GpChatRespond<CR>", { buffer = true, desc = "send to GPT (gp.nvim)" })
		else
			vim.keymap.set(
				"n",
				"<CR>",
				-- Hope to use <leader>t as a leader for many treeistter related things, which this
				-- is in that the code fence is detected via treesitter "language injection"
				function()
					require("femaco.edit").edit_code_block()
				end,
				{ buffer = true, desc = "edit code block" }
			)
		end
	end,
})

-- Nice for folding code blocks
vim.opt_local.foldmethod="expr"
vim.opt_local.foldexpr="nvim_treesitter#foldexpr()"
