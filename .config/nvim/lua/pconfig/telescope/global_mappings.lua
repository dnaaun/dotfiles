local default_lsp_telescope_opts = { fname_width = 60 }

--- @param jump_type "jump" | "vsplit" | "split"
--- @param descriptor_prefix string | nil
local function lsp_gotos_with_jump_type(jump_type, descriptor_prefix, mapping_prefix)
	descriptor_prefix = descriptor_prefix or ""
	mapping_prefix = mapping_prefix or ""
	return {
		{
			mapping_prefix .. "a",
			function()
				vim.lsp.buf.code_action({})
			end,
			desc = descriptor_prefix .. "code actions",
		},
		{
			mapping_prefix .. "r",
			function()
				require("telescope.builtin").lsp_references(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			desc = descriptor_prefix .. "references",
		},
		{
			mapping_prefix .. "t",
			function()
				require("telescope.builtin").lsp_type_definitions(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			desc = descriptor_prefix .. "type definition",
		},
		{
			mapping_prefix .. "d",
			function()
				require("telescope.builtin").lsp_definitions(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			desc = descriptor_prefix .. "definition",
		},
		{
			mapping_prefix .. "w",
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			desc = descriptor_prefix .. "dynamic workspace symbols",
		},
		{
			mapping_prefix .. "e",
			function()
				require("telescope.builtin").diagnostics({
					jump_type = jump_type,
					severity = vim.diagnostic.severity.ERROR,
				})
			end,
			desc = descriptor_prefix .. "diagnostics",
		},
		-- Errors only for current buffer.
		{
			mapping_prefix .. "be",
			function()
				require("telescope.builtin").diagnostics({
					jump_type = jump_type,
					severity = vim.diagnostic.severity.ERROR,
					bufnr = 0,
				})
			end,
			desc = descriptor_prefix .. "buffer diagnostics",
		},
		{
			mapping_prefix .. "ldw",
			function()
				require("telescope.builtin").diagnostics({
					jump_type = jump_type,
					severity = vim.diagnostic.severity.WARN,
				})
			end,
			desc = descriptor_prefix .. "warn diagnostics",
		},
		{
			mapping_prefix .. "ldh",
			function()
				require("telescope.builtin").diagnostics({
					jump_type = jump_type,
					severity = vim.diagnostic.severity.HINT,
				})
			end,
			desc = descriptor_prefix .. "hint diagnostics",
		},
		{
			mapping_prefix .. "i",
			function()
				require("telescope.builtin").lsp_implementations(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			desc = "implementation",
		},
	}
end

local map_telescope_bindings = function()
	-- which-key mappings
	local wk = require("which-key")
	wk.add({
		{
			"<leader>a",
			function()
				require("telescope.builtin").live_grep({
					additional_args = function()
						return { "--hidden" }
					end,
					debounce = 300,
				})
			end,
			desc = "live_grep",
		},
		{
			"<leader>fa", -- a for Aerial
			function()
				require("telescope").extensions.aerial.aerial()
			end,
			desc = "aerial symbols",
		},
		{
			"<leader>s",
			function()
				require("telescope.builtin").fd({
					hidden = true,
				})
			end,
			desc = "fd files in cur dir",
		},
		{
			"<leader>fw",
			function()
				require("telescope.builtin").grep_string({ debounce = 300 })
			end,
			desc = "grep files in cur dir",
		},
		{
			"<leader>b",
			function()
				require("telescope.builtin").buffers({ sort_mru = false })
			end,
			desc = "buffers",
		},
		{ "<leader>h", require("telescope.builtin").oldfiles, desc = "oldfiles" },
		{
			"<leader>w",
			function()
				require("telescope.builtin").grep_string({ word_match = "-w", debounce = 300 })
			end,
			desc = "grep buffer for string",
		},
		{ "<leader>ft", require("telescope.builtin").help_tags, desc = "help_tags" },
		{ "<leader>fj", require("telescope.builtin").jumplist, desc = "jumplist" },
		{ "<leader>f:", require("telescope.builtin").command_history, desc = "command_history" },
		{
			"<leader>f/",
			require("telescope.builtin").current_buffer_fuzzy_find,
			desc = "current_buffer_fuzzy_find",
		},
		{ "<leader>f.", require("telescope.builtin").resume, desc = "last telscope invocation" },
		-- o for restrict to _O_pen files
		{
			"<leader>foa",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					additional_args = function()
						return { "--hidden" }
					end,
				})
			end,
			desc = "grep through dot files",
		},
		-- Repeat the functionality for <leader>b here, cuz the mapping makes sense, I guess.
		{
			"<leader>fos",
			function()
				require("telescope.builtin").buffers({ sort_mru = false })
			end,
			desc = "find dotfiles",
		},
		{
			"<leader>fda",
			function()
				local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
				require("telescope.builtin").live_grep({
					debounce = 300,
					search_dirs = search_dirs,
					additional_args = function()
						return { "--hidden" }
					end,
				})
			end,
			desc = "grep through dot files",
		},
		{
			"<leader>fds",
			function()
				local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
				require("telescope.builtin").fd({ hidden = true, search_dirs = search_dirs, debounce = 300 })
			end,
			desc = "find dotfiles",
		},
		{
			"<leader>fxa",
			function()
				local search_dirs = { vim.fn.expand("~/") .. "Library/CloudStorage/Dropbox/notes/org" }
				require("telescope.builtin").live_grep({
					search_dirs = search_dirs,
					additional_args = function()
						return { "--hidden" }
					end,
				})
			end,
			desc = "grep through org files",
		},
		{
			"<leader>fxs",
			function()
				local search_dirs = { vim.fn.expand("~/") .. "Library/CloudStorage/Dropbox/notes/org" }
				require("telescope.builtin").fd({ hidden = true, search_dirs = search_dirs, debounce = 300 })
			end,
			desc = "find dotfiles",
		},
		{
			"<leader>fgcc",
			function()
				require("telescope.builtin").git_commits()
			end,
			desc = "commits in current branch",
		},
		{
			"<leader>fgcb",
			require("telescope.builtin").git_bcommits,
			desc = "commits that affect current buffer",
		},
		{ "<leader>fgb", require("telescope.builtin").git_branches, desc = "git branches" },
		{
			"<leader>fgd",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "browse diffs and go to file",
		},
		{ "<leader>fh", "<cmd>Telescope harpoon marks<CR>", desc = "harpoon marks" },
		{
			"<C-s>",
			function()
				require("telescope.builtin").fd({ search_dirs = { vim.fn.expand("%:p:h") }, hidden = true })
			end,
			desc = "fd files in cur dir",
		},
		{
			"<C-a>",
			function()
				require("telescope.builtin").live_grep({
					search_dirs = { vim.fn.expand("%:p:h") },
					additional_args = function()
						return { "--hidden" }
					end,
				})
			end,
			desc = "live_grep in cur dir",
		},
	})

	wk.add(lsp_gotos_with_jump_type("vsplit", "LSP vertically", "gx"))
	wk.add(lsp_gotos_with_jump_type("split", "LSP horizontally", "gs"))
	wk.add(lsp_gotos_with_jump_type("jump", "LSP ", "g"))
end

return {
	map_telescope_bindings = map_telescope_bindings,
}
