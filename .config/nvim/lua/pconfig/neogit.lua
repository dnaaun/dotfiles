return {
	"NeogitOrg/neogit",
	dependencies = "nvim-lua/plenary.nvim",
	keys = { "<leader>gn" },
	config = function()
		require("neogit").setup()

		local wk = require("which-key")
		wk.add({
			{ "<leader>gn", require("neogit").open, desc = "Neogits" },
		})
	end,
}
