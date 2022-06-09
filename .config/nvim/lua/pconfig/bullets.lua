return {
	"dkarter/bullets.vim",
	ft = { "markdown", "org" },
	setup = function()
		vim.g.bullets_enabled_file_types = {
      "org",
			"markdown",
			"text",
			"gitcommit",
			"scratch",
		}
	end,
}
