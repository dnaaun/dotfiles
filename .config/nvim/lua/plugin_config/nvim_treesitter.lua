local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.tsx.used_by = { "jsx", "javascriptreact", "typescriptreact" }
parser_config.latex.used_by = {"tex"}

-- -- Setup for nvim-neorg/neorg
-- local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

-- parser_configs.norg = {
-- 	install_info = {
-- 		url = "https://github.com/nvim-neorg/tree-sitter-norg",
-- 		files = { "src/parser.c", "src/scanner.cc" },
-- 		branch = "main",
-- 	},
-- }

-- -- Setup for nvim-orgmode/orgmode
-- parser_config.org = {
-- 	install_info = {
-- 		url = "https://github.com/milisims/tree-sitter-org",
-- 		revision = "main",
-- 		files = { "src/parser.c", "src/scanner.cc" },
-- 	},
-- 	filetype = "org",
-- }

-- Various Treesitter modules config
local highlight = {
	enable = true,
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
			["at"] = "@statement.outer",
		},
	},
	move = {
		enable = true,
		set_jumps = true, -- whether to set jumps in the jumplist
		goto_next_start = {
			["]f"] = "@function.outer",
			["]{"] = "@class.outer",
			["]k"] = "@comment.outer",
			["]b"] = "@block.outer",
			["]c"] = "@call.outer",
			["]i"] = "@conditional.outer",
			["]l"] = "@loop.outer",
			["]p"] = "@parameter.outer",
		},
		goto_next_end = { -- Note that @class.outer is missing
			["]F"] = "@function.outer",
			["]}"] = "@class.outer",
			["]K"] = "@comment.outer",
			["]B"] = "@block.outer",
			["]C"] = "@call.outer",
			["]I"] = "@conditional.outer",
			["]L"] = "@loop.outer",
			["]P"] = "@parameter.outer",
			["]T"] = "@statement.outer",
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
			["[t"] = "@statement.outer",
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
}

local incremental_selection = {
	enable = true,
	keymaps = {
		init_selection = "<CR>",
		node_incremental = "<CR>",
		scope_incremental = "<CR>",
		node_decremental = "g<CR>",
	},
}

require("nvim-treesitter.configs").setup({
	highlight = highlight,
	indent = indent,
	refactor = refactor,
	textobjects = textobjects,
	autotag = autotag,
  incremental_selection=incremental_selection,
	ensure_installed = { "org" },
})

vim.opt.foldexpr="nvim_treesitter#foldexpr()"
