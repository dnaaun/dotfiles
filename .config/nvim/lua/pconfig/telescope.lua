return {
	"nvim-telescope/telescope.nvim",
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
				layout_config = {
					height = 0.99,
					width = 0.99, -- Works better because usually my terminal takes only half my screen
					preview_height = 0.6,
				},
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
		mapfunc("n", "s", function()
			builtin.fd({ hidden = true })
		end, { noremap = true }, "fd")
		mapfunc("n", "<C-s>", function()
			builtin.fd({ search_dirs = { vim.fn.expand("%:p:h") }, hidden = true })
		end, {
			noremap = true,
		}, "fd in cur dir")
		mapfunc("n", "<C-a>", function()
			builtin.live_grep({ search_dirs = { vim.fn.expand("%:p:h") } })
		end, {
			noremap = true,
		}, "live_grep in cur dir")
    -- Is a capital F because it turns out I use lower case f (which stands for
    -- search forward in this line) a bunch.
		mapfunc("n", "<leader>a", builtin.live_grep, { noremap = true }, "live_grep")
		-- Search text through buffers
		mapfunc("n", "<leader>fb", function()
			builtin.live_grep({ grep_open_files = true })
		end, { noremap = true }, "live_grep")
		-- Isn't prefixed with f cuz it's so commonly used
		mapfunc("n", "<leader>b", builtin.buffers, { noremap = true }, "buffers")
		-- Isn't prefixed with f cuz it's so commonly used
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

		local function on_attach()
			buf_mapfunc("n", "gd", function()
				builtin.lsp_definitions({ jump_type = "jump" })
			end, mapping_opts, "go to definition")

			-- Open definition in horizontal splits with gsd
			buf_mapfunc("n", "gsd", function()
				builtin.lsp_definitions({ jump_type = "split" })
			end, mapping_opts, "go to definition in horizontal split")

			-- Open definition in vertical splits with gad.
			buf_mapfunc("n", "gad", function()
				builtin.lsp_definitions({ jump_type = "vsplit" })
			end, mapping_opts, "go to definition in vertical split")

			-- Repeat the same story with splits and going to references as with splits and going to definitions above.
			buf_mapfunc("n", "gr", function()
				builtin.lsp_references({ jump_type = "jump" })
			end, mapping_opts, "go to reference")
			buf_mapfunc("n", "gsr", function()
				builtin.lsp_references({ jump_type = "split" })
			end, mapping_opts, "go to reference in horizontal split")
			buf_mapfunc("n", "gar", function()
				builtin.lsp_references({ jump_type = "jump" })
			end, mapping_opts, "go to reference in vertical split")

			buf_mapfunc("n", "gt", function()
				builtin.lsp_type_definitions({ jump_type = "jump" })
			end, mapping_opts, "go to type definition")
			buf_mapfunc("n", "gst", function()
				builtin.lsp_type_definitions({ jump_type = "split" })
			end, mapping_opts, "go to type definition in horizontal split")
			buf_mapfunc("n", "gat", function()
				builtin.lsp_type_definitions({ jump_type = "jump" })
			end, mapping_opts, "go to type definition in vertical split")

			buf_mapfunc("n", "<leader>li", builtin.lsp_implementations, mapping_opts)
			buf_mapfunc("n", "<leader>le", builtin.diagnostics, mapping_opts, "telescope workspace diagnostics")
			buf_mapfunc(
				"n",
				"<leader>lw",
				builtin.lsp_dynamic_workspace_symbols,
				mapping_opts,
				"telescope dynamic workspace symbols"
			)
		end

		table.insert(_G.lsp_config_on_attach_callbacks, on_attach)
	end,
}
