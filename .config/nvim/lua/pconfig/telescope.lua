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

		-- which-key mappings
		local wk = require("which-key")
		wk.register({
			["-"] = {
				function()
					require("telescope").extensions.file_browser.file_browser({ path = vim.fn.expand("%:p:h") })
				end,
				"file_browser cur dir",
			},
			["<leader>-"] = {
				function()
					require("telescope").extensions.file_browser.file_browser()
				end,
				"file_browser",
			},

			["<leader>"] = {
				a = {
					function()
						builtin.live_grep({
							additional_args = function()
								return { "--hidden" }
							end,
						})
					end,
					"live_grep",
				},

				f = {
					name = "telescopy things",
					w = { builtin.grep_string, "grep buffer for string" },
					b = { builtin.buffers, "buffers" },
					h = { builtin.oldfiles, "oldfiles" },
					t = { builtin.help_tags, "help_tags" },
					j = { builtin.jumplist, "jumplist" },
					[":"] = { builtin.command_history, "command_history" },
					["/"] = { builtin.current_buffer_fuzzy_find, "current_buffer_fuzzy_find" },
					["."] = { builtin.resume, "last telscope invocation" },
					s = {
						function()
							builtin.fd({ hidden = true })
						end,
						"fd files",
					},

					g = {
						name = "git",
						c = {
							name = "commit related",
							c = { builtin.git_commits, "commits in current branch" },
							b = { builtin.git_bcommits, "commits that affect current buffer" },
						},
            b = { builtin.git_branches, "git braches" },
						d = {
							function()
								builtin.git_status(git_preview_opts)
							end,
							"browse diffs and go to file",
						},
					},
				},
			},
			["<C-s>"] = {
				function()
					builtin.fd({ search_dirs = { vim.fn.expand("%:p:h") }, hidden = true })
				end,
				"fd files in cur dir",
			},
			["<C-a>"] = {
				function()
					builtin.live_grep({
						search_dirs = { vim.fn.expand("%:p:h") },
						additional_args = function()
							return { "--hidden" }
						end,
					})
				end,
				"live_grep in cur dir",
			},

			g = vim.tbl_extend("force", {
				x = vim.tbl_extend("force", { name = "open vertically" }, lsp_gotos_with_jump_type("vsplit")),
				s = vim.tbl_extend("force", { name = "open horizontally" }, lsp_gotos_with_jump_type("split")),
				name = "lsp related",
			}, lsp_gotos_with_jump_type("jump", "LSP ")),
		})
	end,
}
