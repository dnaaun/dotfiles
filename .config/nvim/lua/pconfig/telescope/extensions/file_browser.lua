-- utility to get absolute path of target directory for create, copy, moving files/folders
-- https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/6cf29d5139601993343c4e70ee2d1f67959d9cc5/lua/telescope/_extensions/file_browser/actions.lua#L53-L60
local get_target_dir = function(finder)
	local entry_path
	if finder.files == false then
		local entry = action_state.get_selected_entry()
		entry_path = entry and entry.value -- absolute path
	end
	return finder.files and finder.path or entry_path
end

function live_grep_in_cur_telescope_dir(prompt_bufnr)
	-- https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/6cf29d5139601993343c4e70ee2d1f67959d9cc5/lua/telescope/_extensions/file_browser/actions.lua#L117
	local finder = require("telescope.actions.state").get_current_picker(prompt_bufnr).finder
	local base_dir = get_target_dir(finder)

	require("telescope.builtin").live_grep({
		search_dirs = { base_dir },
		additional_args = function()
			return { "--hidden" }
		end,
	})
end

function fd_in_cur_telescope_dir(prompt_bufnr)
	-- https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/6cf29d5139601993343c4e70ee2d1f67959d9cc5/lua/telescope/_extensions/file_browser/actions.lua#L117
	local finder = require("telescope.actions.state").get_current_picker(prompt_bufnr).finder
	local base_dir = get_target_dir(finder)

	require("telescope.builtin").fd({ search_dirs = { base_dir }, hidden = true })
end

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
				["<C-a>"] = live_grep_in_cur_telescope_dir,
				["<C-s>"] = fd_in_cur_telescope_dir,
			},
			["n"] = {
				["-"] = function(prompt_bufnr)
					require("telescope").extensions.file_browser.actions.goto_parent_dir(prompt_bufnr, true)
				end,
				["<C-a>"] = live_grep_in_cur_telescope_dir,
				["<C-s>"] = fd_in_cur_telescope_dir,
			},
		},
	},
}
