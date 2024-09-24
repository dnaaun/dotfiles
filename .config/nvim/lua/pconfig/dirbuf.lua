-- Needed this because something keeps "unmapping" `-` after a bit of time.
local augroup = vim.api.nvim_create_augroup("MyAutocommands", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	callback = function()
		vim.keymap.set("n", "-", "<cmd>Dirbuf<CR>", { desc = "dirbuf" })
	end,
})

return {
	"elihunter173/dirbuf.nvim",
	config = function()
		local wk = require("which-key")
		vim.keymap.set("n", "-", "<cmd>Dirbuf<CR>", { desc = "dirbuf" })
	end,
}
