require("packer").startup({
	function(use)
		-- package/plugin manager
		use(require("pconfig.packer"))
		--
		use({
			"miversen33/import.nvim",
			config = function()
				require("import")
			end,
		})
		use(require("pconfig.tmux"))

		use("embear/vim-localvimrc") -- Enable sourcing .lnvimrc files

    -- cmp-related, might be useful when using neovim in pager mode.
		use(require("pconfig.cmp"))
		use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
		use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })

		-- Used currently for editing JSX mostly
		use(require("pconfig.surround"))

		--  CUrrently used for reapting the things I do with vim-surround
		use({ "tpope/vim-repeat" })


    if _G.PAGER_MODE then
      return
    end

		-- LSP dependent/related
		-- The LSPConfig, the lyth, the legend
		use(require("pconfig.lsp_config"))


		use(require("pconfig.lsp_extensions"))
		-- use(require("pconfig.rust_tools"))

		-- I never use this really.
		-- use(require("pconfig.lsp_lightbulb"))

		-- I use it for slightly nicer UI for lsp code actions
		use(require("pconfig.dressing"))

		-- I'm not using pconfig.notify right now, because it is too noisy (gotta figure out which
		-- error messages are doing it, and how to disable them)
		use(require("pconfig.notify"))

		-- Provides type annotations for neovim's Lua interface. Needs Sumenkos' Lua LSP. TODO: Not actually set up yet: https://github.com/folke/lua-dev.nvim#%EF%B8%8F--configuration
		use(require("pconfig.lua_dev"))

		-- Show func signatures automatically. some filetypes (typescript) cause issues.
		use(require("pconfig.lsp_signature"))
    
    --  Easier installation of LSPs.
		use(require("pconfig.mason"))
		use(require("pconfig.luasnip"))

    -- cmp related, not useful in pager mode.
		use({ "hrsh7th/cmp-nvim-lsp", after = { "nvim-cmp" } })
		use({ "rcarriga/cmp-dap", after = "nvim-cmp" })
		use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })

		-- Super fast, super feature complete, completion plugin
		-- use(require("pconfig.coq"))

		-- Symbol tree. Better than symbols-outline.nvim because it allows filtering by symbol type.
		use(require("pconfig.aerial"))

		-- The package, the pyth, the pegend.
		use(require("pconfig.treesitter"))

		-- Text objects based on syntax trees!!
		use("nvim-treesitter/nvim-treesitter-textobjects")

		-- Treesitter text objects that are "smarter"
		use(require("pconfig.treesitter_subjects"))

		-- Treesitter-based, "virtual-text hinting", text objects. Mind blown emoji. Seriously. Just makes too much sense.
		use(require("pconfig.treehopper"))

		-- I use it for treesitter-based,"virtual-text hinting", jumping/movement.
		use(require("pconfig.syntax_tree_surfer"))

		-- Highlight definition of current symbol, current scope
		-- use("nvim-treesitter/nvim-treesitter-refactor") -- I don't think I've ever used this.

		-- highlight brackets and things like that in differnet colors
		use("p00f/nvim-ts-rainbow")

		use(require("pconfig.rust_tools"))

		-- Debugging/REPLs
		use(require("pconfig.dap"))
		use(require("pconfig.dap_ui"))

		-- Spin up a repl in a neovim terminal and send text to it
		use(require("pconfig.iron"))

		-- Sessions, I really need'em
		use(require("pconfig.auto_session"))

		-- The  unofficial standard library for neovim plugins.
		use("nvim-lua/plenary.nvim")

		-- A see-results-immediately REPL for neovim's lua
		use(require("pconfig.luapad"))

		-- A see-results-immediately REPL for everything that is not noevim's lua.
		use(require("pconfig.codi"))

		-- Turn good ol' linters and formatters to an LSP.
		use(require("pconfig.null_ls"))

		-- (Fuzzy) search everything!
		use(require("pconfig.telescope"))

		-- Git and Github
		-- Look at lines added/modified/taken away, all at a glance.
		use(require("pconfig.gitsigns"))

		-- And I quote tpope, "A git plugin so awesome, it should be illegal."
		use(require("pconfig.fugitive"))

		-- Better diff view
		use(require("pconfig.diffview"))

		-- Who needs web interfaces when you have neovim interfaces (for Github)?
		use(require("pconfig.octo")) -- Not using it

		-- Get a url to the git host, for a range or a line in the current file.
		use(require("pconfig.gitlinker"))

		-- Misc
		use("tpope/vim-commentary") -- (Un)comment stuff with gc
		use("JoosepAlviste/nvim-ts-context-commentstring")

		use(require("pconfig.which_key")) -- show candidate mappings after pressing a key

		-- A quick-and-dirty solution to typing Amharic in vim,
		-- without having to rely on changing the system-wide keyboard layout
		use(require("pconfig.amharic"))

		use(require("pconfig.colorizer"))

		-- Markdown
		use({ "plasticboy/vim-markdown", ft = { "markdown" } })
		use({ "davidgranstrom/nvim-markdown-preview", ft = "markdown" })
		use({ "dhruvasagar/vim-table-mode", ft = { "markdown" } })

		-- Testing things
		use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })

		-- FYI, dispatch.vim is not a strict requirement, but it's nicer.
		-- use(require("pconfig.test"))

		-- An amazing testing plugin. Really showcases the possiblities of treesitter.
		use(require("pconfig.neotest"))

		use("olimorris/neotest-rspec")
		use("rouge8/neotest-rust")

		--use { 'lervag/vimtex',  ft = { 'tex' } }

		-- Colors and other niceties
		use(require("pconfig.zen_mode"))

		use(require("pconfig.web_devicons"))

		-- use("Mofiqul/vscode.nvim")
		use("folke/tokyonight.nvim")

		use(require("pconfig.lualine"))

		-- Capture output of ex commands (slightly quicker than doing :redir /tmp/SOMEFILE | the_ex_command | redir END)
		use(require("pconfig.capture"))

		-- Telescope file browser.
		use(require("pconfig.telescope_file_browser"))

		-- Indicate LSP progress
		use(require("pconfig.fidget"))

		-- vim-matchup
		use(require("pconfig.matchup"))
		-- vim-matchup slows me down, and I *think* this might help solve the issue.
		use("antoinemadec/FixCursorHold.nvim")

		-- Uses a C extension with fzf's algorithim for telescope,
		-- but it causes issues with architecutres not matching up when
		-- I switch from arm64 nvim to x86_64 nvim (which happens when
		-- I switch from, say homebrew neovim to compiled-from-source-neovim,
		-- which happens say, when there's a bug with the nightly version)
		-- So for now, we're disabling.
		use(require("pconfig.telescope_fzf_native"))

		-- Foray into orgmode once more
		use(require("pconfig.orgmode"))

		-- Hopefully this one solves some point points with nvim-orgmode (like bullets not
		-- working properly)
		use(require("pconfig.neorg"))

		-- Show me where I'm at in the status bar (like, what funciton/ conditional/thingy)
		use(require("pconfig.treesitter_context"))

		-- Treesitter offiical plugin to show treesitter parses
		-- Ya boy is going to start writing plugins at this rate!
		use(require("pconfig.playground"))

		-- Convert between all the cases, with LSP and preview integration
		use(require("pconfig.text_case"))

		-- use cht.sh easily inside vim
		use(require("pconfig.cheat"))

		-- sometimes, I want `thisWord` to take two "word" motions to traverse,
		-- because it's camel cased.
		-- use(require("pconfig.wordmotion"))

		-- should help with file navigation a lot
		use(require("pconfig.harpoon"))

		-- nvim-autopairs
		use(require("pconfig.autopairs"))

		-- match autotag
		use(require("pconfig.ts_autotag"))

		-- Put bullets on next line if the current one has bullets
		use(require("pconfig.bullets"))

		-- Show the open buffers in a tab line at the top
		use(require("pconfig.bufferline"))

		-- use(require("pconfig.sqls"))

    use(require("pconfig.codewindow"))

    -- structural search and replce.
    use(require("pconfig.ssr"))

    -- I use it for: jump to a locaiton in the jumplist that is in a different
    -- buffer than the one I have now.
    use(require("pconfig.portal"))
	end,

	config = {
		git = {
			clone_timeout = 1800, -- 30 minutes
		},
	},
})

-- At end of quickstart section, https://github.com/wbthomason/packer.nvim#quickstart one finds
-- this snippet, because running PackerCompile is needed to "refresh" configuration for Packer.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> |  PackerCompile
    " Reload packer, after reloading the lua module corresponding to the packer config for a plugin, when the packer config file is edited.
    " TODO (David): Write a function for heavens sake.
    autocmd BufWritePost *pconfig/*.lua call v:lua.require('plenary.reload').reload_module('pconfig.' .. expand('<afile>:t:r'), 1) |  source ~/.config/nvim/lua/plugins.lua | PackerCompile
  augroup end
]])
