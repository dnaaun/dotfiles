return {
	"petertriho/cmp-git",
	requires = "nvim-lua/plenary.nvim",
	config = function()
		require("cmp_git").setup({
			-- defaults
			filetypes = { "gitcommit", "octo" },
			remotes = { "origin" },
		})
	end,
}
