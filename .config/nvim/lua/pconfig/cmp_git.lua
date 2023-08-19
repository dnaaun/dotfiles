return {
	"petertriho/cmp-git",
	config = function()
		require("cmp_git").setup({
      filetypes = { "gitcommit", "octo", "org" },
    })
	end,
}
