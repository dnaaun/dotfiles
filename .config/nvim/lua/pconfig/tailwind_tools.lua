return {
	"luckasRanarison/tailwind-tools.nvim",
	name = "tailwind-tools",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim", -- optional
		"neovim/nvim-lspconfig", -- optional
	},

	opts = {
		extension = {
			document_color = {
				enabled = false, -- can be toggled by commands
				kind = "inline", -- "inline" | "foreground" | "background"
				inline_symbol = "󰝤 ", -- only used in inline mode
				debounce = 200, -- in milliseconds, only applied in insert mode
			},
			queries = {},
			patterns = {
				rust = {
					-- "class=[\"']([^\"']+)[\"']",

					-- This isn't working, so :shrug: for now.
					"class=%([\"']([^\"']+)[\"']",
				},
			},
		},
	}, -- your configuration
}
