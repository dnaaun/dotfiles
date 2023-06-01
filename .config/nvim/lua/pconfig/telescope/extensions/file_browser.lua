return {
	setup = { -- Requires the telescope-file-browser
		opts = {
			respect_gitignore = false,
		},
		mappings = {
			["i"] = {
				["<C-b>"] = function(prompt_bufnr)
					require("telescope").extensions.file_browser.actions.goto_parent_dir(prompt_bufnr, true)
				end,
			},
			["n"] = {
				["-"] = function(prompt_bufnr)
					require("telescope").extensions.file_browser.actions.goto_parent_dir(prompt_bufnr, true)
				end,
			},
		},
	},
}
