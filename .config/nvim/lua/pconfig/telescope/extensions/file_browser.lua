-- utility to get absolute path of target directory for create, copy, moving files/folders
-- https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/6cf29d5139601993343c4e70ee2d1f67959d9cc5/lua/telescope/_extensions/file_browser/actions.lua#L53-L60
local search_dir = require("pconfig.telescope.search_dir")

---@param finder table
---@return string|nil
local get_target_dir = function(finder)
	local entry_path
	if finder.files == false then
		local action_state = require("telescope.actions.state")
		local entry = action_state.get_selected_entry()
		entry_path = entry and entry.value -- absolute path
	end
	return finder.files and finder.path or entry_path
end

---@param prompt_bufnr integer
---@return nil
local function goto_parent_dir(prompt_bufnr)
	require("telescope").extensions.file_browser.actions.goto_parent_dir(prompt_bufnr, true)
end

---@param prompt_bufnr integer
---@return nil
function live_grep_in_cur_telescope_dir(prompt_bufnr)
	-- https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/6cf29d5139601993343c4e70ee2d1f67959d9cc5/lua/telescope/_extensions/file_browser/actions.lua#L117
	local finder = require("telescope.actions.state").get_current_picker(prompt_bufnr).finder
	local base_dir = get_target_dir(finder)

	require("telescope.builtin").live_grep(search_dir.live_grep_opts(base_dir))
end

---@param prompt_bufnr integer
---@return nil
function fd_in_cur_telescope_dir(prompt_bufnr)
	-- https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/6cf29d5139601993343c4e70ee2d1f67959d9cc5/lua/telescope/_extensions/file_browser/actions.lua#L117
	local finder = require("telescope.actions.state").get_current_picker(prompt_bufnr).finder
	local base_dir = get_target_dir(finder)

	require("telescope.builtin").fd(search_dir.fd_opts(base_dir))
end

return {
	setup = { -- Requires the telescope-file-browser
		opts = {
			respect_gitignore = false,
		},
		mappings = {
			["i"] = {
				["<C-b>"] = goto_parent_dir,
				["<C-a>"] = live_grep_in_cur_telescope_dir,
				["<C-s>"] = fd_in_cur_telescope_dir,
			},
			["n"] = {
				["-"] = goto_parent_dir,
				["<C-a>"] = live_grep_in_cur_telescope_dir,
				["<C-s>"] = fd_in_cur_telescope_dir,
			},
		},
	},
}
