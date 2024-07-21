return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		layout = {
			height = { min = 4, max = 200 },
			width = { min = 20, max = 200 }, -- min and max width of the columns
		},
		disable = {
			filetypes = {
				-- I added this here I use neovim as a pager for pgcli (and maybe other things),
				-- and I set `nomodifiable` there (also `nowrap`, but I think that's irrelevant),
				-- and I believe that is preventing which-key from working, which means that
				-- even basic things like yanking text are erroring out.
				"terminal",
			},
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
