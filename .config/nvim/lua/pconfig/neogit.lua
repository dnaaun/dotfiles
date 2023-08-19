return {
	"NeogitOrg/neogit",
	dependencies = "nvim-lua/plenary.nvim",
	keys = { "<leader>gn" },
	config = function()
		require("neogit").setup()

		local wk = require("which-key")
		wk.register({
			["<leader>g"] = {
				n = { require("neogit").open, "Neogit" },
			},
		})
	end,
}
