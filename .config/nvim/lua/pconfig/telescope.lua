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

		local default_lsp_telescope_opts = { fname_width = 60 }

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
						builtin.lsp_references(
							vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
						)
					end,
					descriptor_prefix .. "references",
				},
				t = {
					function()
						builtin.lsp_type_definitions(
							vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
						)
					end,
					descriptor_prefix .. "type definition",
				},
				d = {
					function()
						builtin.lsp_definitions(
							vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
						)
					end,
					descriptor_prefix .. "definition",
				},
				w = {
					function()
						builtin.lsp_dynamic_workspace_symbols(
							vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
						)
					end,
					descriptor_prefix .. "dynamic workspace symbols",
				},
				e = {
					function()
						builtin.diagnostics({ jump_type = jump_type, severity = vim.diagnostic.severity.ERROR })
					end,
					descriptor_prefix .. "diagnostics",
				},
				-- Errors only for current buffer.
				be = {
					function()
						builtin.diagnostics({
							jump_type = jump_type,
							severity = vim.diagnostic.severity.ERROR,
							bufnr = 0,
						})
					end,
					descriptor_prefix .. "buffer diagnostics",
				},
				l = {
					name = "less often used LSP mappings",
					d = {
						name = "diagnostics by error level",
						w = {
							function()
								builtin.diagnostics({ jump_type = jump_type, severity = vim.diagnostic.severity.WARN })
							end,
							descriptor_prefix .. "warn diagnostics",
						},
					},
				},
				i = {
					function()
						builtin.lsp_implementations(
							vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
						)
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
			["-"] = {
				function()
					require("telescope").extensions.file_browser.file_browser({
						path = vim.fn.expand("%:p:h"),
						respect_gitignore = false,
					})
				end,
				"file_browser cur dir",
			},
			["<leader>-"] = {
				function()
					require("telescope").extensions.file_browser.file_browser({
						respect_gitignore = false,
					})
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
				s = {
					function()
						builtin.fd({
							hidden = true,
						})
					end,
					"fd files in cur dir",
				},
				b = { builtin.buffers, "buffers" },
				h = { builtin.oldfiles, "oldfiles" },

				f = {
					name = "telescopy things",
					w = {
						function()
							builtin.grep_string({ word_match = "-w" })
						end,
						"grep buffer for string",
					},
					t = { builtin.help_tags, "help_tags" },
					j = { builtin.jumplist, "jumplist" },
					[":"] = { builtin.command_history, "command_history" },
					["/"] = { builtin.current_buffer_fuzzy_find, "current_buffer_fuzzy_find" },
					["."] = { builtin.resume, "last telscope invocation" },
					d = {
						a = {
							function()
								local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
								builtin.live_grep({
									search_dirs = search_dirs,
									additional_args = function()
										return { "--hidden" }
									end,
								})
							end,
							"grep through dot files",
						},
						s = {
							function()
								local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
								builtin.fd({ hidden = true, search_dirs = search_dirs })
							end,
							"find dotfiles",
						},

						name = "look through dot files",
					},

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
						b = { builtin.git_branches, "git branches" },
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
