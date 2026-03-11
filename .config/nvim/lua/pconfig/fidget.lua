return {
	"j-hui/fidget.nvim",
	branch = "legacy", -- otherwise I get errors on startup
	event = "LspAttach",
	config = function()
		require("fidget").setup({})
	end,
}
