return {
	"cshuaimin/ssr.nvim",

	-- I found out about this because I got errors without treeistter.
	dependencies = "nvim-treesitter/nvim-treesitter",

	keys = { "<leader>ls" },
	lazy = true,

	-- Calling setup is optional.
	config = function()
		vim.keymap.set({ "n", "x" }, "<leader>ls", function() require("ssr").open() end, { desc = "Structural Search and Replace with Treeesitter" })

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
