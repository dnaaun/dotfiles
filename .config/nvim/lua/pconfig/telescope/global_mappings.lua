local default_lsp_telescope_opts = { fname_width = 60 }
local search_dir = require("pconfig.telescope.search_dir")

---@return string
local function current_file_dir()
	local buffer_name = vim.api.nvim_buf_get_name(0)
	if buffer_name == "" then
		return vim.uv.cwd()
	end

	return vim.fn.fnamemodify(buffer_name, ":p:h")
end

---@return string[]
local function hidden_arg()
	return search_dir.hidden_arg()
end

---@param prefix string
---@param dir string
---@return string
local function current_file_dir_title(prefix, dir)
	return prefix .. " in " .. vim.fn.fnamemodify(dir, ":~:.")
end

---@return nil
local function fd_in_current_file_dir()
	local dir = current_file_dir()
	require("telescope.builtin").fd(search_dir.fd_opts(dir, {
		debounce = 300,
		prompt_title = current_file_dir_title("fd", dir),
	}))
end

---@return nil
local function live_grep_in_current_file_dir()
	local dir = current_file_dir()
	require("telescope.builtin").live_grep(search_dir.live_grep_opts(dir, {
		debounce = 300,
		prompt_title = current_file_dir_title("live_grep", dir),
	}))
end

--- @param jump_type "jump" | "vsplit" | "split"
--- @param descriptor_prefix string | nil
--- @param mapping_prefix string | nil
--- @return nil
local function lsp_gotos_with_jump_type(jump_type, descriptor_prefix, mapping_prefix)
	descriptor_prefix = descriptor_prefix or ""
	mapping_prefix = mapping_prefix or ""
	vim.keymap.set("n", mapping_prefix .. "a", function()
		vim.lsp.buf.code_action({})
	end, { desc = descriptor_prefix .. "code actions" })
	vim.keymap.set("n", mapping_prefix .. "r", function()
		require("telescope.builtin").lsp_references(
			vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
		)
	end, { desc = descriptor_prefix .. "references" })
	vim.keymap.set("n", mapping_prefix .. "t", function()
		require("telescope.builtin").lsp_type_definitions(
			vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
		)
	end, { desc = descriptor_prefix .. "type definition" })
	vim.keymap.set("n", mapping_prefix .. "d", function()
		require("telescope.builtin").lsp_definitions(
			vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
		)
	end, { desc = descriptor_prefix .. "definition" })
	vim.keymap.set("n", mapping_prefix .. "w", function()
		require("telescope.builtin").lsp_dynamic_workspace_symbols(
			vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
		)
	end, { desc = descriptor_prefix .. "dynamic workspace symbols" })
	vim.keymap.set("n", mapping_prefix .. "e", function()
		require("telescope.builtin").diagnostics({
			jump_type = jump_type,
			severity = vim.diagnostic.severity.ERROR,
		})
	end, { desc = descriptor_prefix .. "diagnostics" })
	-- Errors only for current buffer.
	vim.keymap.set("n", mapping_prefix .. "be", function()
		require("telescope.builtin").diagnostics({
			jump_type = jump_type,
			severity = vim.diagnostic.severity.ERROR,
			bufnr = 0,
		})
	end, { desc = descriptor_prefix .. "buffer diagnostics" })
	vim.keymap.set("n", mapping_prefix .. "ldw", function()
		require("telescope.builtin").diagnostics({
			jump_type = jump_type,
			severity = vim.diagnostic.severity.WARN,
		})
	end, { desc = descriptor_prefix .. "warn diagnostics" })
	vim.keymap.set("n", mapping_prefix .. "ldh", function()
		require("telescope.builtin").diagnostics({
			jump_type = jump_type,
			severity = vim.diagnostic.severity.HINT,
		})
	end, { desc = descriptor_prefix .. "hint diagnostics" })
	vim.keymap.set("n", mapping_prefix .. "i", function()
		require("telescope.builtin").lsp_implementations(
			vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
		)
	end, { desc = "implementation" })
end

---@return nil
local map_telescope_bindings = function()
	vim.keymap.set("n", "<leader>a", function()
		require("telescope.builtin").live_grep({
			additional_args = hidden_arg,
			debounce = 300,
		})
	end, { desc = "live_grep" })
	vim.keymap.set("n", "<leader>fa", function()
		require("telescope").extensions.aerial.aerial()
	end, { desc = "aerial symbols" })
	vim.keymap.set("n", "<leader>s", function()
		require("telescope.builtin").fd({
			hidden = true,
			no_ignore = false,
			no_ignore_parent = false,
		})
	end, { desc = "fd files in cur dir" })
	vim.keymap.set("n", "<leader>fw", function()
		require("telescope.builtin").grep_string({ debounce = 300 })
	end, { desc = "grep files in cur dir" })
	vim.keymap.set("n", "<leader>b", function()
		require("telescope.builtin").buffers({ sort_mru = false })
	end, { desc = "buffers" })
	vim.keymap.set("n", "<leader>h", function()
		require("telescope.builtin").oldfiles()
	end, { desc = "oldfiles" })
	vim.keymap.set("n", "<leader>w", function()
		require("telescope.builtin").grep_string({ word_match = "-w", debounce = 300 })
	end, { desc = "grep buffer for string" })
	vim.keymap.set("n", "<leader>ft", function()
		require("telescope.builtin").help_tags()
	end, { desc = "help_tags" })
	vim.keymap.set("n", "<leader>fj", function()
		require("telescope.builtin").jumplist()
	end, { desc = "jumplist" })
	vim.keymap.set("n", "<leader>f:", function()
		require("telescope.builtin").command_history()
	end, { desc = "command_history" })
	vim.keymap.set("n", "<leader>f/", function()
		require("telescope.builtin").current_buffer_fuzzy_find()
	end, { desc = "current_buffer_fuzzy_find" })
	vim.keymap.set("n", "<leader>f.", function()
		require("telescope.builtin").resume()
	end, { desc = "last telscope invocation" })
	-- o for restrict to _O_pen files
	vim.keymap.set("n", "<leader>foa", function()
		require("telescope.builtin").live_grep({
			grep_open_files = true,
			additional_args = hidden_arg,
		})
	end, { desc = "grep through dot files" })
	-- Repeat the functionality for <leader>b here, cuz the mapping makes sense, I guess.
	vim.keymap.set("n", "<leader>fos", function()
		require("telescope.builtin").buffers({ sort_mru = false })
	end, { desc = "find dotfiles" })
	vim.keymap.set("n", "<leader>fda", function()
		local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
		require("telescope.builtin").live_grep({
			debounce = 300,
			search_dirs = search_dirs,
			additional_args = hidden_arg,
		})
	end, { desc = "grep through dot files" })
	vim.keymap.set("n", "<leader>fds", function()
		local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
		require("telescope.builtin").fd({ hidden = true, search_dirs = search_dirs, debounce = 300 })
	end, { desc = "find dotfiles" })
	vim.keymap.set("n", "<leader>fxa", function()
		local search_dirs = { vim.fn.expand("~/") .. "Library/CloudStorage/Dropbox/notes/org" }
		require("telescope.builtin").live_grep({
			search_dirs = search_dirs,
			additional_args = hidden_arg,
		})
	end, { desc = "grep through org files" })
	vim.keymap.set("n", "<leader>fxs", function()
		local search_dirs = { vim.fn.expand("~/") .. "Library/CloudStorage/Dropbox/notes/org" }
		require("telescope.builtin").fd({ hidden = true, search_dirs = search_dirs, debounce = 300 })
	end, { desc = "find dotfiles" })
	vim.keymap.set("n", "<leader>fgcc", function()
		require("telescope.builtin").git_commits()
	end, { desc = "commits in current branch" })
	vim.keymap.set("n", "<leader>fgcb", function()
		require("telescope.builtin").git_bcommits()
	end, { desc = "commits that affect current buffer" })
	vim.keymap.set("n", "<leader>fgb", function()
		require("telescope.builtin").git_branches()
	end, { desc = "git branches" })
	vim.keymap.set("n", "<leader>fgd", function()
		require("telescope.builtin").git_status()
	end, { desc = "browse diffs and go to file" })
	vim.keymap.set("n", "<leader>fh", "<cmd>Telescope harpoon marks<CR>", { desc = "harpoon marks" })
	vim.keymap.set("n", "<C-s>", fd_in_current_file_dir, { desc = "fd files in cur dir" })
	vim.keymap.set("n", "<C-a>", live_grep_in_current_file_dir, { desc = "live_grep in cur dir" })
	vim.keymap.set("n", "<leader>fcs", fd_in_current_file_dir, { desc = "fd files in cur dir" })
	vim.keymap.set("n", "<leader>fca", live_grep_in_current_file_dir, { desc = "live_grep in cur dir" })

	lsp_gotos_with_jump_type("vsplit", "LSP vertically", "gx")
	lsp_gotos_with_jump_type("split", "LSP horizontally", "gs")
	lsp_gotos_with_jump_type("jump", "LSP ", "g")
end

return {
	map_telescope_bindings = map_telescope_bindings,
}
