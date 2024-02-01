return {
  -- ChatGPT/GPT-4 plugin.
  require("pconfig.gp"),

  require("pconfig.fire"),
	
	require("pconfig.tmux"),

	-- (Fuzzy) search everything!
	require("pconfig.telescope"),
	require("pconfig.telescope_file_browser"),
	{ "Marskey/telescope-sg" },
	require("pconfig.dirbuf"),

	require("pconfig.which_key"), -- show candidate mappings after pressing a key

	-- Git and Github
	-- Look at lines added/modified/taken away, all at a glance.
	require("pconfig.gitsigns"),

	-- Misc
	"tpope/vim-commentary", -- (Un)comment stuff with gc
	-- "JoosepAlviste/nvim-ts-context-commentstring",

	-- Sessions, I really need'em
	require("pconfig.auto_session"),

	-- Debugging/REPLs
	require("pconfig.dap"),
	require("pconfig.dap_ui"),

	require("pconfig.copilot"),

	require("pconfig.lsp_config"),
	require("pconfig.lsp_extensions"),
	require("pconfig.rust_tools"),
	-- require("pconfig.lsp_inlayhints"),

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
	{ "rcarriga/cmp-dap", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	{ "saadparwaiz1/cmp_luasnip", dependencies = "hrsh7th/nvim-cmp", event = require("pconfig.cmp").event },
	require("pconfig.cmp_git"),
	-- Colors and other niceties
	require("pconfig.zen_mode"),

	require("pconfig.luasnip"),

	-- I'm using this mostly to filter out error messages
	-- require("pconfig.noice"),

	-- Get a url to the git host, for a range or a line in the current file.
	require("pconfig.gitlinker"),

	-- Does one thing: map `dd` inside the quickfix list to "remove item from quicklist"
	{ "TamaMcGlinn/quickfixdd", event = "VeryLazy" },

	-- I use it for: jump to a locaiton in the jumplist that is in a different
	-- buffer than the one I have now.
	-- require("pconfig.portal"),
	require("pconfig.bufjump"),

	-- should help with file navigation a lot
	require("pconfig.harpoon"),

	-- nvim-autopairs
	require("pconfig.autopairs"),

	-- match autotag
	require("pconfig.ts_autotag"),

	-- Put bullets on next line if the current one has bullets
	require("pconfig.bullets"),

	-- Show the open buffers in a tab line at the top
	require("pconfig.bufferline"),

	require("pconfig.codewindow"),

	-- structural search and replce.
	require("pconfig.ssr"),

	-- Convert between all the cases, with LSP and preview integration
	require("pconfig.text_case"),

	-- { "lervag/vimtex", ft = { "tex" } },

	-- Turn good ol' linters and formatters to an LSP.
	require("pconfig.null_ls"),

	-- use("Mofiqul/vscode.nvim")
	-- use("folke/tokyonight.nvim")
	{ "EdenEast/nightfox.nvim", event = "VeryLazy" },

	-- vim-matchup
	require("pconfig.matchup"),
	-- vim-matchup slows me down, and I *think* this might help solve the issue.
	"antoinemadec/FixCursorHold.nvim",

	require("pconfig.surround"),

	-- The package, the pyth, the pegend.
	require("pconfig.treesitter"),

	-- Text objects based on syntax trees!!
  -- DISABLED: cuz it's causing when editing Rust files, and files have to be "force saved"
	-- { "nvim-treesitter/nvim-treesitter-textobjects", event = require("pconfig.treesitter").event },
 
	-- I use it for treesitter-based,"virtual-text hinting", jumping/movement.
	require("pconfig.syntax_tree_surfer"),
	--		-- Treesitter-based, "virtual-text hinting", text objects. Mind blown emoji. Seriously. Just makes too much sense.
	require("pconfig.treehopper"),

	-- I use it for slightly nicer UI for lsp code actions
	require("pconfig.dressing"),

	-- Provides type annotations for neovim's Lua interface. Needs Sumenkos' Lua LSP. TODO: Not actually set up yet: https://github.com/folke/lua-dev.nvim#%EF%B8%8F--configuration
	require("pconfig.lua_dev"),

	-- Look at all diagnostics in workspace/document. Hopefully useful for refactoring/adding typescript.
	require("pconfig.trouble"),

	-- highlight brackets and things like that in differnet colors
	-- I don't think I've ever paid aattention to the colors of brackets ever.
	-- {
	-- 	"p00f/nvim-ts-rainbow",
	-- 	dependencies = "nvim-treesitter/nvim-treesitter",
	-- 	event = { "InsertEnter" },
	-- },

	-- Spin up a repl in a neovim terminal and send text to it
	require("pconfig.iron"),

	-- A see-results-immediately REPL for neovim's lua
	require("pconfig.luapad"),

	-- A see-results-immediately REPL for everything that is not noevim's lua.
	require("pconfig.codi"),

	-- And I quote tpope, "A git plugin so awesome, it should be illegal."
	require("pconfig.fugitive"),

	require("pconfig.neogit"),

	--		-- Better diff view
	require("pconfig.diffview"),

	-- Who needs web interfaces when you have neovim interfaces (for Github)?
	require("pconfig.octo"),

	--		-- A quick-and-dirty solution to typing Amharic in vim,
	--		-- without having to rely on changing the system-wide keyboard layout
	require("pconfig.amharic"),

	require("pconfig.colorizer"),

	--		-- Markdown
	{ "plasticboy/vim-markdown", ft = { "markdown" }, event = "VeryLazy" },
	{ "davidgranstrom/nvim-markdown-preview", ft = "markdown", cmd = "MarkdownPreview" },
	{ "dhruvasagar/vim-table-mode", ft = { "markdown" }, event = "InsertLeave" },

	-- Testing things
	{ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } },

	--		-- An amazing testing plugin. Really showcases the possiblities of treesitter.
	require("pconfig.neotest"),
	{ "haydenmeade/neotest-jest", event = "VeryLazy", ft = require("consts").javascripty_filetypes },
	{ "olimorris/neotest-rspec", ft = "ruby" },
	{ "rouge8/neotest-rust", ft = "rust" },

	require("pconfig.web_devicons"),

	require("pconfig.lualine"),

	--		-- Capture output of ex commands (slightly quicker than doing :redir /tmp/SOMEFILE | the_ex_command | redir END)
	require("pconfig.capture"),

	--		-- Indicate LSP progress
	require("pconfig.fidget"),

	-- Uses a C extension with fzf's algorithim for telescope,
	-- but it causes issues with architecutres not matching up when
	-- I switch from arm64 nvim to x86_64 nvim (which happens when
	-- I switch from, say homebrew neovim to compiled-from-source-neovim,
	-- which happens say, when there's a bug with the nightly version)
	-- So for now, we're disabling.
	require("pconfig.telescope_fzf_native"),

	-- Hopefully this one solves some point points with nvim-orgmode (like bullets not
	-- working properly)
	-- require("pconfig.neorg"),

	-- Show me where I'm at in the status bar (like, what funciton/ conditional/thingy)
	require("pconfig.treesitter_context"),

	-- Treesitter offiical plugin to show treesitter parses
	-- Ya boy is going to start writing plugins at this rate!
	require("pconfig.playground"),

	-- Something I've personally wanted for a long time, hope they managed to make it work really well.
	require("pconfig.devdocs"),

	-- Supposed to be a "stirpped down VimWiki". Let's see if it is indeed.
	-- UPDATE: Haven't used kiwi ever, so abandoning. I'm settling into orgmode anways.
	-- require("pconfig.kiwi"),
	-- Here we go again. I really do want to give orgmode another try, since I keep on re-inventing it in my head again and again.
	require("pconfig.orgmode"),
  -- Run snippets of code in markdown/orgmode
  require("pconfig.sniprun"),
  require("pconfig.telescope_orgmode"),

	-- Sourcegraph stuff from TJ
	require("pconfig.sg"),

	-- Make it easier to runc arog commands from neovim. Maybe git too, who knows.
	require("pconfig.overseer"),

	-- Highlight occurences of current word
	require("pconfig.mini_cursorword"),

  -- Code outline
  require("pconfig.aerial"),
}
