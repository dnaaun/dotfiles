require("pconfig.telescope.global_mappings")

return {
	"nvim-telescope/telescope.nvim",
	module = true,
	keys = {
		"<C-a>",
		"<C-f>",
		"<leader>f",
		"-",
		"<leader>-",
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
			},
			pickers = {
				buffers = {
					mappings = {
						i = {
							["<c-d>"] = "delete_buffer",
						},
						n = {
							["<c-d>"] = "delete_buffer",
						},
					},
				},
			},
			extensions = {
				fzf = require("pconfig.telescope.extensions.fzf").setup,
				file_browser = require("pconfig.telescope.extensions.file_browser").setup,
			},
		})
	end,
	dependencies = { "nvim-lua/plenary.nvim" },
}
