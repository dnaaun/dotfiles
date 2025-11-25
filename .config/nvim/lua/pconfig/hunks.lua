return {
	"julienvincent/hunk.nvim",
	cmd = { "DiffEditor" },
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-mini/mini.icons",
	},
	config = function()
		require("hunk").setup()
	end,
}
