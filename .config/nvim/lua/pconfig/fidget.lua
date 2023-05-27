return {
	"j-hui/fidget.nvim",
  event = require("pconfig.lsp_config").event,
	dependencies = { "nvim-lspconfig" },
	config = function()
		require("fidget").setup({})
	end,
}
