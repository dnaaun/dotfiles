return {
	"petertriho/cmp-git",
	ft = { "gitcommit", "octo", "org" },
	config = function()
		require("cmp_git").setup({
			filetypes = { "gitcommit", "octo", "org" },
		})
	end,
}
