return {
	"j-hui/fidget.nvim",
  branch = "legacy", -- otherwise I get errors on startup
  event = require("pconfig.lsp_config").event,
	dependencies = { "nvim-lspconfig" },
	config = function()
		require("fidget").setup({})
	end,
}
