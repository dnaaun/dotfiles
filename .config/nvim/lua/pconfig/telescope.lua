return {
	"nvim-telescope/telescope.nvim",
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

		local builtin = require("telescope.builtin")
		mapfunc("n", "<leader>fw", builtin.grep_string, { noremap = true }, "grep_string")
		mapfunc("n", "<leader>s", function()
			builtin.fd({ hidden = true })
		end, { noremap = true }, "fd")
		mapfunc("n", "<C-s>", function()
			builtin.fd({ search_dirs = { vim.fn.expand("%:p:h") }, hidden = true })
		end, {
			noremap = true,
		}, "fd in cur dir")
		mapfunc("n", "<C-a>", function()
			builtin.live_grep({
				search_dirs = { vim.fn.expand("%:p:h") },
				additional_args = function()
					return { "--hidden" }
				end,
			})
		end, {
			noremap = true,
		}, "live_grep in cur dir")
		-- Is a capital F because it turns out I use lower case f (which stands for
		-- search forward in this line) a bunch.
		mapfunc("n", "<leader>a", function()
			builtin.live_grep({
				additional_args = function()
					return { "--hidden" }
				end,
			})
		end, { noremap = true }, "live_grep")
		-- Search text through buffers
		mapfunc("n", "<leader>fb", function()
			builtin.live_grep({
				grep_open_files = true,
				additional_args = function()
					return { "--hidden" }
				end,
			})
		end, { noremap = true }, "live_grep")
		mapfunc("n", "<leader>b", builtin.buffers, { noremap = true }, "buffers")
		mapfunc("n", "<leader>h", builtin.oldfiles, { noremap = true }, "oldfiles")
		mapfunc("n", "<leader>ft", builtin.help_tags, { noremap = true }, "help_tags")
		mapfunc("n", "<leader>f:", builtin.command_history, { noremap = true }, "command_history")
		mapfunc("n", "<leader>f/", builtin.current_buffer_fuzzy_find, { noremap = true }, "current_buffer_fuzzy_find")
		mapfunc("n", "<leader>fj", builtin.jumplist, { noremap = true }, "jumplist")
		mapfunc("n", "<leader>f.", builtin.resume, { noremap = true }, "resume")
		mapfunc("n", "-", function()
			require("telescope").extensions.file_browser.file_browser({ path = vim.fn.expand("%:p:h") })
		end, {}, "file_browser cur dir")
		mapfunc("n", ",-", function()
			require("telescope").extensions.file_browser.file_browser()
		end, {}, "file_browser")

		mapfunc("n", "<leader>fgcc", builtin.git_commits, {}, "Git commits")
		mapfunc("n", "<leader>fgcb", builtin.git_bcommits, {}, "Git buffer commits")
		mapfunc("n", "<leader>fgb", builtin.git_branches, {}, "Git branches")

		-- I search through my dot files a lot, d stands for dotfiles,
		-- and then use a and s in line with my live_grep and fd mappings above.
		vim.keymap.set("n", "<leader>fda", function()
			local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
			builtin.live_grep({
				search_dirs = search_dirs,
				additional_args = function()
					return { "--hidden" }
				end,
			})
		end, {})
		vim.keymap.set("n", "<leader>fds", function()
			local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
			builtin.fd({ hidden = true, search_dirs = search_dirs })
		end, {})

		--- @param jump_type "jump" | "vsplit" | "split"
		--- @param descriptor_prefix string | nil
		local function lsp_gotos_with_jump_type(jump_type, descriptor_prefix)
			descriptor_prefix = descriptor_prefix or ""
			return {
				a = {
					function()
						vim.lsp.buf.code_action({})
					end,
					descriptor_prefix .. "code actions",
				},
				r = {
					function()
						builtin.lsp_references({ jump_type = jump_type })
					end,
					descriptor_prefix .. "references",
				},
				t = {
					function()
						builtin.lsp_type_definitions({ jump_type = jump_type })
					end,
					descriptor_prefix .. "type definition",
				},
				d = {
					function()
						builtin.lsp_definitions({ jump_type = jump_type })
					end,
					descriptor_prefix .. "definition",
				},
				w = {
					function()
						builtin.lsp_dynamic_workspace_symbols({ jump_type = jump_type })
					end,
					descriptor_prefix .. "dynamic workspace symbols",
				},
				e = {
					function()
						builtin.diagnostics({ jump_type = jump_type, severity = vim.diagnostic.severity.ERROR })
					end,
					descriptor_prefix .. "diagnostics",
				},
				i = {
					function()
						builtin.lsp_implementations({ jump_type = jump_type })
					end,
					"implementation",
				},
			}
		end

		-- Setup difftastic as the diff tool when previewing git diffs with the telescope git commands:

		local previewers = require("telescope.previewers")

		local difftastic = previewers.new_termopen_previewer({
			get_command = function(entry)
				-- this is for status
				-- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
				-- just do an if and return a different command
				if entry.status == "??" or "A " then
					return { "git", "-c", "core.pager=difft", "diff", entry.value }
				end

				-- note we can't use pipes
				-- this command is for git_commits and git_bcommits
				return { "git", "-c", "core.pager=difft", "diff", entry.value .. "^!" }
			end,
		})

		local git_preview_opts = { previewer = difftastic }

		-- which-key mappings
		local wk = require("which-key")
		wk.register({
			["<leader>f"] = {
				g = {
					name = "git",
					d = {
						function()
							builtin.git_status(git_preview_opts)
						end,
						"browse diffs and go to file",
					},
				},
			},
			g = vim.tbl_extend("force", {
				x = vim.tbl_extend("force", { name = "open vertically" }, lsp_gotos_with_jump_type("vsplit")),
				s = vim.tbl_extend("force", { name = "open horizontally" }, lsp_gotos_with_jump_type("split")),
			}, lsp_gotos_with_jump_type("jump", "LSP ")),
		})
	end,
}
