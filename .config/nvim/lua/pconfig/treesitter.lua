return {
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",

	config = function()
		local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
		-- use tsserver for
		ft_to_parser.jsx = "tsx"
		ft_to_parser.javascriptreact = "tsx"
		ft_to_parser.typescriptreact = "tsx"
		ft_to_parser.tex = "latex"

		-- Various Treesitter modules config
		local highlight = {
			enable = false,
			disable = { "markdown", "org" }, -- Markdown is slow (I think), and org is experimental.
			-- additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
		}
		local indent = {
			enable = false,
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
					["]F"] = "@function.outer",
					["]}"] = "@class.outer",
					["]K"] = "@comment.outer",
					["]B"] = "@block.outer",
					["]C"] = "@call.outer",
					["]I"] = "@conditional.outer",
					["]L"] = "@loop.outer",
					["]P"] = "@parameter.inner",
					-- ["]T"] = "@statement.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[{"] = "@class.outer",
					["[k"] = "@comment.outer",
					["[b"] = "@block.outer",
					["[c"] = "@call.outer",
					["[i"] = "@conditional.outer",
					["[l"] = "@loop.outer",
					["[p"] = "@parameter.outer",
					-- ["[t"] = "@statement.outer",
				},
				goto_previous_end = { -- Note that @class.outer is missing
					["[F"] = "@function.outer",
					["[}"] = "@class.outer",
					["[K"] = "@comment.outer",
					["[B"] = "@block.outer",
					["[C"] = "@call.outer",
					["[I"] = "@conditional.outer",
					["[L"] = "@loop.outer",
					["[P"] = "@parameter.outer",
					--["[T"] = "@statement.outer",
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
		}

		local incremental_selection = {
			enable = false,
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				scope_incremental = "<CR>",
				node_decremental = "g<CR>",
			},
		}

		local matchup = { -- vim-matchup experimental support for treesitter
			enable = true,
		}

		require("nvim-treesitter.configs").setup({
			highlight = highlight,
			indent = indent,
			refactor = refactor,
			textobjects = textobjects,
			autotag = autotag,
			incremental_selection = incremental_selection,
			matchup = matchup,
		})

		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	end,
}
