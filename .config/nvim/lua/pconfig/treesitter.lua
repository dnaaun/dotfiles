return {
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",

	config = function()
		local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
		-- use tsserver for
		ft_to_parser.jsx = "tsx"
		ft_to_parser.javascriptreact = "tsx"
		ft_to_parser.typescriptreact = "tsx" -- TODO: Remove this since you have ftdetectk/tsx.lua that sets filetype=tsx
		ft_to_parser.tex = "latex"

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
			disable = { "markdown", "org" }, -- Markdown is slow (I think), and org is experimental.
			-- additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
		}
		local indent = {
			enable = true,
		}
		-- requires https://github.com/nvim-treesitter/nvim-treesitter-refactor
		local refactor = {
			highlight_definitions = { enable = true },
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

		local autotag = {
			enable = true,
			filetypes = {
				"html",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"svelte",
				"vue",
				"tsx",
				"jsx",
				"rescript",
				"xml",
				"php",
				"markdown",
				"glimmer",
				"handlebars",
				"hbs",
			},
		}

		local incremental_selection = {
			enable = true,
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

		local ensure_installed = { "tsx" }

		-- treesitter playground taht shows you the nodes
		local playground = {
			enable = true,
		}

		-- requires the nvim-ts-context-commentstring plugin
		local context_commentstring = {
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
			context_commentstring = context_commentstring,
			ensure_installed = ensure_installed,
			highlight = highlight,
			indent = indent,
			refactor = refactor,
			textobjects = textobjects,
			-- textsubjects = textsubjects,
			autotag = autotag,
			incremental_selection = incremental_selection,
			matchup = matchup,
			playground = playground,
			rainbow = rainbow,
		})

		-- I don't like how (I blieve this is what is causing it) the org file folidng is working out.
		-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	end,
}
