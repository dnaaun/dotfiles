return {
	-- Plugins I don't use right now, but I configured them at some poitn and think it might be useful to keep that confiugration (or even the mere mention) of these plugins around:
	-- require("pconfig.dap"),
	-- require("pconfig.dap_ui"),
	-- require("pconfig.rust_tools"),
	-- require("pconfig.mason"),
	-- require("pconfig.mason_lspconfig"),
	-- require("pconfig.neotest"), -- freezes vim on startup
	-- { "haydenmeade/neotest-jest", event = "VeryLazy", ft = require("consts").javascripty_filetypes },
	-- { "olimorris/neotest-rspec", ft = "ruby" },
	-- { "rouge8/neotest-rust", ft = "rust" },

	-- I think these two cause TS errors.
	-- {
	-- 		"JoosepAlviste/nvim-ts-context-commentstring",
	-- 		event = "VeryLazy",
	-- 		config = function()
	-- 			require("ts_context_commentstring").setup({})
	-- 		end,
	-- 	},
	-- require("pconfig.telescope_ast_grep"),
	-- require("pconfig.copilot"),
	-- 	{
	-- 		"ray-x/lsp_signature.nvim",
	-- 		-- event = "VeryLazy",
	-- 		opts = {},
	-- 		config = function(_, opts)
	-- 			require("lsp_signature").setup(opts)
	-- 		end,
	-- 	},

	require("pconfig.which_key"), -- show candidate mappings after pressing a key
	require("pconfig.telescope"),
	require("pconfig.telescope_file_browser"),
	require("pconfig.lsp_config"),

	require("pconfig.cmp"),
	{ "hrsh7th/cmp-buffer", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "hrsh7th/cmp-nvim-lsp", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	-- { "itchyny/vim-qfedit" },

	-- vim-matchup
	require("pconfig.matchup"),

	-- The package, the pyth, the pegend.
	require("pconfig.treesitter"),

	require("pconfig.treehopper"),

	-- Here we go again. I really do want to give orgmode another try, since I keep on re-inventing it in my head again and again.
	require("pconfig.orgmode"),

	require("pconfig.tmux"),

	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- require("pconfig.dressing"),
	require("pconfig.treesitter_unit"),

	----------------------- These errors don't cause the neovim freeze. ------------------
	require("pconfig.dirbuf"),
	require("pconfig.surround"),
	{ "nanotee/sqls.nvim" },
	require("pconfig.web_devicons"),
	require("pconfig.lualine"),
	require("pconfig.fidget"),
	require("pconfig.telescope_fzf_native"),
	require("pconfig.mini_cursorword"),
	require("pconfig.aerial"),
	require("pconfig.femaco"),
	require("pconfig.otter"),
	require("pconfig.diffview"),
	require("pconfig.amharic"),
	require("pconfig.bullets"),
	require("pconfig.iron"),
	require("pconfig.neogit"),
	require("pconfig.gitsigns"),
	require("pconfig.auto_session"),
	require("pconfig.zen_mode"),
	require("pconfig.text_case"),
	require("pconfig.lint"),
	{ "hrsh7th/cmp-path", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "hrsh7th/cmp-cmdline", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "f3fora/cmp-spell", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.conform"),
	-- require("pconfig.copilot_cmp"),
	-- { "rcarriga/cmp-dap", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.gp"),
	require("pconfig.treesitter_context"),
	require("pconfig.luasnip"),
	{ "saadparwaiz1/cmp_luasnip", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
  require("pconfig.harpoon")
}
