return {
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	event = "VeryLazy",
	config = function()
		vim.treesitter.language.register("tsx", {
			"javascript",
			"typescript",
			"tsx",
			"jsx",
			"javascriptreact",
			"typescriptreact",
		})

		vim.treesitter.language.register("latex", {
			"tex",
			"latex",
		})

		local textsubjects = {
			enable = false,
			prev_selection = "<C-CR>", -- (Optional) keymap to select the previous selection
			keymaps = {
				["<CR>"] = "textsubjects-smart",
				[";"] = "textsubjects-container-outer",
				["i;"] = "textsubjects-container-inner",
			},
		}

		-- Various Treesitter modules config
		local highlight = {
			enable = true,
			disable = {
        -- "org"
			},
		}
		local indent = {
			enable = false,
			disable = {
				"ruby",
			},
		}
		-- requires https://github.com/nvim-treesitter/nvim-treesitter-refactor
		local refactor = {
			highlight_definitions = { enable = false },
			--highlight_current_scope = { enable = true },
		}
		-- requires https://github.com/nvim-treesitter/nvim-treesitter-textobjects ( or some
		-- link like that)
		local textobjects = {
			select = {
				enable = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["a{"] = "@class.outer",
					["i{"] = "@class.inner",
					["ak"] = "@comment.outer",
					["ib"] = "@block.inner",
					["ab"] = "@block.outer",
					["ic"] = "@call.inner",
					["ac"] = "@call.outer",
					["ii"] = "@conditional.inner", -- i for *i*f statement
					["ai"] = "@conditional.outer",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
					["ip"] = "@parameter.inner",
					["ap"] = "@parameter.outer",
					["is"] = "@scopename.inner",
					-- ["at"] = "@statement.outer", -- I never use it, and it conflicts with "a tag".
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				-- disabled ]t, ]T, etc because we want to use it for vim-test/vim-ultest
				goto_next_start = {
					-- I'm using syntax_tree_surfer, so no need to do this.
					["]f"] = "@function.outer",
					["]{"] = "@class.outer",
					["]k"] = "@comment.outer",
					["]b"] = "@block.outer",
					["]c"] = "@call.outer",
					["]i"] = "@conditional.outer",
					["]l"] = "@loop.outer",
					["]p"] = "@parameter.inner",
				},
				goto_next_end = { -- Note that @class.outer is missing
					-- I'm using syntax_tree_surfer, so no need to do this.
					["]F"] = "@function.outer",
					["]}"] = "@class.outer",
					["]K"] = "@comment.outer",
					["]B"] = "@block.outer",
					["]C"] = "@call.outer",
					["]I"] = "@conditional.outer",
					["]L"] = "@loop.outer",
					["]P"] = "@parameter.inner",
					["]T"] = "@statement.outer",
				},
				goto_previous_start = {
					-- I'm using syntax_tree_surfer, so no need to do this.
					["[f"] = "@function.outer",
					["[{"] = "@class.outer",
					["[k"] = "@comment.outer",
					["[b"] = "@block.outer",
					["[c"] = "@call.outer",
					["[i"] = "@conditional.outer",
					["[l"] = "@loop.outer",
					["[p"] = "@parameter.outer",
					["[t"] = "@statement.outer",
				},
				goto_previous_end = { -- Note that @class.outer is missing
					-- I'm using syntax_tree_surfer, so no need to do this.
					["[F"] = "@function.outer",
					["[}"] = "@class.outer",
					["[K"] = "@comment.outer",
					["[B"] = "@block.outer",
					["[C"] = "@call.outer",
					["[I"] = "@conditional.outer",
					["[L"] = "@loop.outer",
					["[P"] = "@parameter.outer",
					["[T"] = "@statement.outer",
				},
			},
			lsp_interop = {
				enable = true,
				border = "none",
				peek_definition_code = {
					["<leader>ld"] = "@function.outer",
					["<leader>lD"] = "@class.outer",
				},
			},
		}

		local incremental_selection = {
			enable = false,
			disable = function(_, buf)
				-- Disable for markdown files because I want to use <CR> in my GPT plugin for
				-- "send", and incremental selection interferes with that.
				if vim.bo[buf].filetype == "markdown" then
					return true
				end

				if vim.bo[buf].filetype == "tex" then
					return true -- Doesn't work for tex
				end

				-- Otherwise, it interferes with "command-line window"
				if vim.fn.getbufvar(buf, "&buftype") == "nofile" then
					return true
				end
			end,
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				--scope_incremental = "<CR>",
				node_decremental = "g<CR>",
			},
		}

		local matchup = { -- vim-matchup experimental support for treesitter
			enable = true,

			-- Matchcup is indispensible, but it's slow, so I'll disable as
			-- much as I can the features apart from "jump to matching tag".
			disable_virtual_text = true,
			include_match_words = false,
		}

		local ensure_installed = { "tsx", "html", "lua", "ruby", "python", "rust", "markdown" }

		-- treesitter playground taht shows you the nodes
		local playground = {
			enable = true,
		}

		local rainbow = {
			enable = true,
			-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
			extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
			max_file_lines = nil, -- Do not enable for files with more than n lines, int
			-- colors = {}, -- table of hex strings
			-- termcolors = {} -- table of colour name strings
		}

		require("nvim-treesitter.configs").setup({
			ensure_installed = ensure_installed,
			highlight = highlight,
			indent = indent,
			refactor = refactor,
			textobjects = textobjects,
			-- textsubjects = textsubjects,
			incremental_selection = incremental_selection,
			-- matchup = matchup,
			playground = playground,
			rainbow = rainbow,
			ensure_installed = ensure_installed,
		})

		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldtext = ""
	end,
}
