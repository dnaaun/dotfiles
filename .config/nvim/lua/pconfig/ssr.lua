return {
	"cshuaimin/ssr.nvim",
	module = "ssr",
	-- Calling setup is optional.
	setup = function()
		require("which-key").register({
			["<leader>"] = {
				l = {
					s = {
            -- Additional funciton wrapping to avoid requiring ssr on vim load
						function()
							require("ssr").open()
						end,
						"Structural Search and Replace with Treeesitter",
					},
				},
			},
		}, { mode = { "n", "x" } })
	end,
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
