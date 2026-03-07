require("pconfig.telescope.global_mappings").map_telescope_bindings()

return {
	"nvim-telescope/telescope.nvim",
  lazy = true,
	config = function()
		local telescope = require("telescope")

		telescope.load_extension("fzf")

		-- I think this is out of date with ormgmode.nvim
		-- telescope.load_extension('orgmode')

		-- R-e-enable when re-enabling erial
		-- require("telescope").load_extension("aerial")

		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
				mappings = { i = { ["<esc>"] = false } },
			},
			pickers = {
				find_files = { mappings = { i = { ["<esc>"] = false } } },
				grep_string = { mappings = { i = { ["<esc>"] = false } } },
				live_grep = { mappings = { i = { ["<esc>"] = false } } },
				buffers = {
					mappings = {
						i = {
							["<c-d>"] = "delete_buffer",
							["<esc>"] = false,
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
				ast_grep = {
					command = {
						"sg",
						"--json=stream",
					},
					grep_open_files = false, -- search in opened files
					lang = nil, -- string value, specify language for ast-grep `nil` for default
				},
			},
		})
	end,
	dependencies = { "nvim-lua/plenary.nvim" },
}
