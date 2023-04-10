return {
	"TimUntersberger/neogit",
	requires = "nvim-lua/plenary.nvim",
	config = function()
		require("neogit").setup()

		local wk = require("which-key")
	end,
}
