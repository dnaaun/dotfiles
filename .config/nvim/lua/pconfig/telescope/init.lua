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
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
				},

				file_browser = { -- Requires the telescope-file-browser
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
			},
		})
		-- Mappings
		local mapping_opts = { noremap = true }
		local mapfunc = require("std2").mapfunc
		local buf_mapfunc = require("std2").buf_mapfunc


		-- Setup difftastic as the diff tool when previewing git diffs with the telescope git commands:

		local previewers = require("telescope.previewers")

		local difftastic = previewers.new_termopen_previewer({
			get_command = function(entry)
				-- this is for status
				-- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
				-- just do an if and return a different command
				if entry.status == "??" or "A " then
					return { "echo", "git", "-c", "core.pager=difft", "diff", entry.value }
				end

				-- note we can't use pipes
				-- this command is for git_commits and git_bcommits
				return { "echo", "git", "-c", "core.pager=difft", "diff", entry.value .. "^!" }
			end,
		})

		local git_preview_opts = { previewer = difftastic }
	end,
	dependencies = { "nvim-lua/plenary.nvim" },
}
