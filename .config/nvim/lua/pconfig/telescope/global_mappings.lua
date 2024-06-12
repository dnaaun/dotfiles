local default_lsp_telescope_opts = { fname_width = 60 }

--- @param jump_type "jump" | "vsplit" | "split"
--- @param descriptor_prefix string | nil
local function lsp_gotos_with_jump_type(jump_type, descriptor_prefix)
	-- Note, I delay requiring telescope.builtin as late as possible because
	-- I want to delay loading the telescope plugin to when one of the keyamppings
	-- is used (which I've setup with lazy.nvim).
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
				require("telescope.builtin").lsp_references(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			descriptor_prefix .. "references",
		},
		t = {
			function()
				require("telescope.builtin").lsp_type_definitions(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			descriptor_prefix .. "type definition",
		},
		d = {
			function()
				require("telescope.builtin").lsp_definitions(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			descriptor_prefix .. "definition",
		},
		w = {
			function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			descriptor_prefix .. "dynamic workspace symbols",
		},
		e = {
			function()
				require("telescope.builtin").diagnostics({
					jump_type = jump_type,
					severity = vim.diagnostic.severity.ERROR,
				})
			end,
			descriptor_prefix .. "diagnostics",
		},
		-- Errors only for current buffer.
		be = {
			function()
				require("telescope.builtin").diagnostics({
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
						require("telescope.builtin").diagnostics({
							jump_type = jump_type,
							severity = vim.diagnostic.severity.WARN,
						})
					end,
					descriptor_prefix .. "warn diagnostics",
				},
				h = {
					function()
						require("telescope.builtin").diagnostics({
							jump_type = jump_type,
							severity = vim.diagnostic.severity.HINT,
						})
					end,
					descriptor_prefix .. "hint diagnostics",
				},
			},
		},
		i = {
			function()
				require("telescope.builtin").lsp_implementations(
					vim.tbl_extend("force", {}, default_lsp_telescope_opts, { jump_type = jump_type })
				)
			end,
			"implementation",
		},
	}
end

local map_telescope_bindings = function()
	-- which-key mappings
	local wk = require("which-key")
	wk.register({
		-- ["-"] = {
		-- 	function()
		-- 		require("telescope").extensions.file_browser.file_browser({
		-- 			path = vim.fn.expand("%:p:h"),
		-- 			respect_gitignore = false,
		-- 		})
		-- 	end,
		-- 	"file_browser cur dir",
		-- },
		-- ["<leader>-"] = {
		-- 	function()
		-- 		require("telescope").extensions.file_browser.file_browser({
		-- 			respect_gitignore = false,
		-- 		})
		-- 	end,
		-- 	"file_browser",
		-- },

		["<leader>"] = {
			a = {
				function()
					require("telescope.builtin").live_grep({
						additional_args = function()
							return { "--hidden" }
						end,
					})
				end,
				"live_grep",
			},
			s = {
				function()
					require("telescope.builtin").fd({
						hidden = true,
					})
				end,
				"fd files in cur dir",
			},
			b = {
				function()
					require("telescope.builtin").buffers({ sort_mru = false })
				end,
				"buffers",
			},
			h = { require("telescope.builtin").oldfiles, "oldfiles" },

			f = {
				name = "telescopy things",
				w = {
					function()
						require("telescope.builtin").grep_string({ word_match = "-w" })
					end,
					"grep buffer for string",
				},
				t = { require("telescope.builtin").help_tags, "help_tags" },
				j = { require("telescope.builtin").jumplist, "jumplist" },
				[":"] = { require("telescope.builtin").command_history, "command_history" },
				["/"] = { require("telescope.builtin").current_buffer_fuzzy_find, "current_buffer_fuzzy_find" },
				["."] = { require("telescope.builtin").resume, "last telscope invocation" },

				-- o for restrict to _O_pen files
				o = {
					a = {
						function()
							require("telescope.builtin").live_grep({
								grep_open_files = true,
								additional_args = function()
									return { "--hidden" }
								end,
							})
						end,
						"grep through dot files",
					},

          -- Repeat the functionality for <leader>b here, cuz the mapping makes sense, I guess.
					s = {
						function()
							require("telescope.builtin").buffers({ sort_mru = false })
						end,
						"find dotfiles",
					},

					name = "look through dot files",
				},
				d = {
					a = {
						function()
							local search_dirs = { vim.fn.expand("~/") .. "git/dotfiles/" }
							require("telescope.builtin").live_grep({
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
							require("telescope.builtin").fd({ hidden = true, search_dirs = search_dirs })
						end,
						"find dotfiles",
					},

					name = "look through dot files",
				},
				x = {
					a = {
						function()
							local search_dirs = { vim.fn.expand("~/") .. "Dropbox/notes/org" }
							require("telescope.builtin").live_grep({
								search_dirs = search_dirs,
								additional_args = function()
									return { "--hidden" }
								end,
							})
						end,
						"grep through org files",
					},
					s = {
						function()
							local search_dirs = { vim.fn.expand("~/") .. "Dropbox/notes/org" }
							require("telescope.builtin").fd({ hidden = true, search_dirs = search_dirs })
						end,
						"find dotfiles",
					},

					name = "look through org files",
				},

				s = {
					function()
						require("telescope.builtin").fd({ hidden = true })
					end,
					"fd files",
				},

				g = {
					name = "git",
					c = {
						name = "commit related",
						c = {
							function()
								require("telescope.builtin").git_commits()
							end,
							"commits in current branch",
						},
						b = { require("telescope.builtin").git_bcommits, "commits that affect current buffer" },
					},
					b = { require("telescope.builtin").git_branches, "git branches" },
					d = {
						function()
							require("telescope.builtin").git_status()
						end,
						"browse diffs and go to file",
					},
				},
				h = {
					"<cmd>Telescope harpoon marks<CR>",
					"harpoon marks",
				},
			},
		},
		["<C-s>"] = {
			function()
				require("telescope.builtin").fd({ search_dirs = { vim.fn.expand("%:p:h") }, hidden = true })
			end,
			"fd files in cur dir",
		},
		["<C-a>"] = {
			function()
				require("telescope.builtin").live_grep({
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
end

return {
	map_telescope_bindings = map_telescope_bindings,
}
