return {
	-- require("pconfig.mason"),
	-- require("pconfig.mason_lspconfig"),
	require("pconfig.which_key"), -- show candidate mappings after pressing a key

	-- use("Mofiqul/vscode.nvim")
	-- use("folke/tokyonight.nvim")
	-- { "EdenEast/nightfox.nvim", event = "VeryLazy" },
	-- require("pconfig.surround"),

	-- ChatGPT/GPT-4 plugin.
	-- require("pconfig.gp"),
	-- require("pconfig.dirbuf"),
	-- Debugging/REPLs
	-- require("pconfig.dap"),
	-- require("pconfig.dap_ui"),
	-- require("pconfig.rust_tools"),
	-- { "nanotee/sqls.nvim" },

	-- require("pconfig.fire"),

	-- An amazing testing plugin. Really showcases the possiblities of treesitter.
	-- require("pconfig.neotest"), -- freezes vim on startup
	-- { "haydenmeade/neotest-jest", event = "VeryLazy", ft = require("consts").javascripty_filetypes },
	-- { "olimorris/neotest-rspec", ft = "ruby" },
	-- { "rouge8/neotest-rust", ft = "rust" },

	-- require("pconfig.web_devicons"),

	-- require("pconfig.lualine"),

	-- Capture output of ex commands (slightly quicker than doing :redir /tmp/SOMEFILE | the_ex_command | redir END)
	-- require("pconfig.capture"),

	--		-- Indicate LSP progress
	-- require("pconfig.fidget"),

	-- Hopefully this one solves some point points with nvim-orgmode (like bullets not
	-- working properly)
	-- require("pconfig.neorg"),

	-- Show me where I'm at in the status bar (like, what funciton/ conditional/thingy)
	-- require("pconfig.treesitter_context"),
	-- {
	-- 		"JoosepAlviste/nvim-ts-context-commentstring",
	-- 		event = "VeryLazy",
	-- 		config = function()
	-- 			require("ts_context_commentstring").setup({})
	-- 		end,
	-- 	},
	-- {
	-- 	"echasnovski/mini.nvim",
	-- 	version = "*",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("mini.comment").setup()
	-- 	end,
	-- },
	-- Uses a C extension with fzf's algorithim for telescope.
	-- require("pconfig.telescope_fzf_native"),
	-- Integgrate with ast-grep
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
	-- Make it easier to runc arog commands from neovim. Maybe git too, who knows.
	-- require("pconfig.overseer"),
	-- Highlight occurences of current word
	-- require("pconfig.mini_cursorword"),
	-- Code outline
	-- require("pconfig.aerial"),

	-- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- Markdown/notebook related
	-- require("pconfig.femaco"),
	-- require("pconfig.otter"),
	-- Look at all diagnostics in workspace/document. Hopefully useful for refactoring/adding typescript.
	-- require("pconfig.trouble"),

	-- And I quote tpope, "A git plugin so awesome, it should be illegal."
	-- require("pconfig.fugitive"),

	--		-- Better diff view
	-- require("pconfig.diffview"),

	-- Who needs web interfaces when you have neovim interfaces (for Github)?
	-- require("pconfig.octo"),

	--		-- A quick-and-dirty solution to typing Amharic in vim,
	--		-- without having to rely on changing the system-wide keyboard layout
	-- require("pconfig.amharic"),

	-- require("pconfig.colorizer"),

	-- { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },

	-- { "dhruvasagar/vim-table-mode", ft = { "markdown" }, event = "InsertLeave" },
	-- Show the open buffers in a tab line at the top
	-- require("pconfig.bufferline"),

	-- structural search and replce.
	-- require("pconfig.ssr"),
	-- Put bullets on next line if the current one has bullets
	-- require("pconfig.bullets"),


	-- Testing things
	-- { "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } },
	-- (Fuzzy) search everything!
	require("pconfig.telescope"),
	require("pconfig.telescope_file_browser"),
	-- { "Marskey/telescope-sg" },

	-- I think this is out of date with ormgmode.nvim
	-- require("pconfig.telescope_orgmode"),

	-- Git and Github
	-- Look at lines added/modified/taken away, all at a glance.
	-- require("pconfig.gitsigns"),

	-- Sessions, I really need'em
	require("pconfig.auto_session"),

	require("pconfig.lsp_config"),
	require("pconfig.lsp_extensions"),

	-- cmp-related, might be useful when using neovim in pager mode.
	require("pconfig.cmp"),
	{ "hrsh7th/cmp-buffer", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "hrsh7th/cmp-path", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "hrsh7th/cmp-cmdline", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "f3fora/cmp-spell", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
		event = require("pconfig.cmp").event,
	},
	{ "hrsh7th/cmp-nvim-lsp", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	-- { "rcarriga/cmp-dap", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "saadparwaiz1/cmp_luasnip", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	-- require("pconfig.cmp_git"),
	-- Colors and other niceties
	require("pconfig.zen_mode"),

	require("pconfig.luasnip"),


	-- edit the quickfix like it's a real buffer (and changes ot file names, as well as
	-- file contents are persisted)
	{ "itchyny/vim-qfedit" },

	-- Convert between all the cases, with LSP and preview integration
	require("pconfig.text_case"),

	-- { "lervag/vimtex", ft = { "tex" } },

	-- Turn good ol' linters and formatters to an LSP.
	require("pconfig.lint"),
	require("pconfig.conform"),

	-- vim-matchup
	require("pconfig.matchup"),

	-- The package, the pyth, the pegend.
	require("pconfig.treesitter"),

	-- Text objects based on syntax trees!!
	-- DISABLED: cuz it's causing when editing Rust files, and files have to be "force saved"
	-- { "nvim-treesitter/nvim-treesitter-textobjects", event = require("pconfig.treesitter").event },

	-- I use it for treesitter-based,"virtual-text hinting", jumping/movement.
	require("pconfig.syntax_tree_surfer"),
	--		-- Treesitter-based, "virtual-text hinting", text objects. Mind blown emoji. Seriously. Just makes too much sense.
	require("pconfig.treehopper"),

	-- "remote" text objects
	-- require("pconfig.spooky"),

	-- Treesitter-based extraction of react JSX/TSX into a separate file
	require("pconfig.react_extract"),

	-- I use it for slightly nicer UI for lsp code actions
	require("pconfig.dressing"),

	-- Provides type annotations for neovim's Lua interface. Needs Sumenkos' Lua LSP. TODO: Not actually set up yet: https://github.com/folke/lua-dev.nvim#%EF%B8%8F--configuration
	require("pconfig.lua_dev"),


	-- highlight brackets and things like that in differnet colors
	-- I don't think I've ever paid aattention to the colors of brackets ever.
	-- {
	-- 	"p00f/nvim-ts-rainbow",
	-- 	dependencies = "nvim-treesitter/nvim-treesitter",
	-- 	event = { "InsertEnter" },
	-- },

	-- Spin up a repl in a neovim terminal and send text to it
	require("pconfig.iron"),


	require("pconfig.neogit"),

	-- Here we go again. I really do want to give orgmode another try, since I keep on re-inventing it in my head again and again.
	require("pconfig.orgmode"),

	require("pconfig.tmux"),

}
