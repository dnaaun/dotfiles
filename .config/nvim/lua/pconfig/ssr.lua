return {
	"cshuaimin/ssr.nvim",
	module = "ssr",
	-- Calling setup is optional.
	config = function()
		require("ssr").setup({
			min_width = 50,
			min_height = 5,
			keymaps = {
				close = "q",
				next_match = "n",
				prev_match = "N",
				replace_all = "<leader><cr>",
			},
		})
	end,
}
