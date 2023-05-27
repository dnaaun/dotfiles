return {
	"pwntester/octo.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("octo").setup({
      github_hostname = "github.com"
    })
	end,
}
