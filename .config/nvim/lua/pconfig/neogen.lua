return {
	"danymat/neogen",
	config = function()
		require("neogen").setup({
			snippet_engine = "luasnip",
		})
	end,
	requires = "nvim-treesitter/nvim-treesitter",
	-- Uncomment next line if you want to follow only stable versions
	-- tag = "*"
}
