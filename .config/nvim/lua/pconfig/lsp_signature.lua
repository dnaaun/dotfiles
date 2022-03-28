return {
	"ray-x/lsp_signature.nvim",
	ft = require("consts").lsp_enabled_filetypes,
	after = { "nvim-lspconfig" },
	config = function()
		require("lsp_signature").setup({ hint_enable = true, fix_pos = true })
	end,
}
