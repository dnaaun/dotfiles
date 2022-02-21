return {
	"ray-x/lsp_signature.nvim",
	ft = require('consts').lsp_enabled_filetypes,
	after = { "nvim-lspconfig" },
	config = function()
		table.insert(_G.lsp_config_on_attach_callbacks, function()
			require("lsp_signature").on_attach()
		end)
	end,
}
