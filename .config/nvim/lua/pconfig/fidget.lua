return {
	"j-hui/fidget.nvim",
  branch = "legacy", -- otherwise I get errors on startup
	config = function()
		require("fidget").setup({})
	end,
}
