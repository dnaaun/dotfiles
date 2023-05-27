return {
	"ruifm/gitlinker.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	keys = { "<leader>gy" },
	config = function()
		require("gitlinker").setup({

			opts = {
				action_callback = require("gitlinker.actions").copy_to_clipboard,
				-- print the url after performing the action
				print_url = true,
				mappings = "<leader>gy",
			},
			callbacks = {
				["github-surge"] = function(url_data)
					url_data.host = "github.com"
					return require("gitlinker.hosts").get_github_type_url(url_data)
				end,
			},
		})
	end,
}
