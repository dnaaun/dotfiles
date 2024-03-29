return {
	"folke/zen-mode.nvim",
	branch = "main",
	keys = { "<leader>vz" },
	config = function()
		require("zen-mode").setup({
			window = {
				width = 0.85,
			},
		})
		vim.keymap.set("n", "<leader>vz", require("zen-mode").toggle, {})
	end,
}
