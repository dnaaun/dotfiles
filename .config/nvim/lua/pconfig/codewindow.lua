return {
	"gorbit99/codewindow.nvim",
	keys = {
		"<leader>mo",
		"<leader>mc",
		"<leader>mt",
		"<leader>mf",
	},
	config = function()
		local codewindow = require("codewindow")
		codewindow.setup()
		local wk = require("which-key")
		wk.register({
			["<leader>m"] = {
				o = { codewindow.open_minimap, "open minimap" },
				c = { codewindow.close_minimap, "close minimap" },
				t = { codewindow.toggle_minimap, "toggle minimap" },
				f = { codewindow.toggle_minimap, "toggle minimap focus" },
			},
		})
	end,
}
