return {
	"folke/zen-mode.nvim",
	branch = "main",
	keys = { "<leader>vz" },
	config = function()
		require("zen-mode").setup({
			plugins = {
				tmux = { enabled = false },
			},
			window = {
				width = 100,
				height = 0.95,
				backdrop = 1,
				options = {
					signcolumn = "no",
					number = false,
					cursorline = false,
					cursorcolumn = false,
					foldcolumn = "0",
					list = false,
				},
			},
		})
		vim.keymap.set("n", "<leader>vz", require("zen-mode").toggle, {})
	end,
}
