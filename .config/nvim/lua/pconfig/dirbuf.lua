return {
	"elihunter173/dirbuf.nvim",
	config = function()
		local wk = require("which-key")
		vim.keymap.set("n", "-", "<cmd>Dirbuf<CR>", { desc = "dirbuf" })
	end,
}
