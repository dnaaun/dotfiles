-- NOTE: Btw, this requires a "patched font", and after trying out
-- Iosevka and FiraCode, JetBrainsMono Nerd Font is what worked for me.
return {
	"folke/trouble.nvim",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics win.position=right<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist <cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist <cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
