return {
	"TimUntersberger/neogit",
	requires = "nvim-lua/plenary.nvim",
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
