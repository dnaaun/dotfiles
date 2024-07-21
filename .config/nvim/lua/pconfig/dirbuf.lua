return {
	"elihunter173/dirbuf.nvim",
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "-", "<cmd>Dirbuf<CR>", desc = "dirbuf" },
		})
	end,
}

