require("packer").startup({
	function(use)
		-- package/plugin manager
		use(require("pconfig.packer"))

		use(require("pconfig.tmux_navigator"))

		use("embear/vim-localvimrc") -- Enable sourcing .lnvimrc files
		use(require("pconfig.indent_blankline"))

		-- When opening splits, let the remaining one remain "stable"
		use(require("pconfig.stabilize"))

		-- LSP dependent/related
		-- The LSPConfig, the lyth, the legend
		use(require("pconfig.lsp_config"))

		-- TODO: Setup inlay hints for rust, or just fix rust-tools.nvim's inlay hints
		use(require("pconfig.lsp_extensions"))

		use(require("pconfig.lsp_lightbulb"))

		-- Provides type annotations for neovim's Lua interface. Needs Sumenkos' Lua LSP. TODO: Not actually set up yet: https://github.com/folke/lua-dev.nvim#%EF%B8%8F--configuration
		use(require("pconfig.lua_dev"))

		-- Show func signatures automatically. some filetypes (typescript) cause issues.
		use(require("pconfig.lsp_signature"))

		use("hrsh7th/cmp-nvim-lsp")
		use("hrsh7th/cmp-buffer")
		use("hrsh7th/cmp-path")
		use("hrsh7th/cmp-cmdline")

		use(require("pconfig.luasnip"))
		use({ "saadparwaiz1/cmp_luasnip" })

		use(require("pconfig.cmp"))

		-- Super fast, super feature complete, completion plugin
		-- use(require("pconfig.coq"))

		-- Symbol tree. Better than symbols-outline.nvim because it allows filtering by symbol type.
		use(require("pconfig.aerial"))

		-- The package, the pyth, the pegend.
		use(require("pconfig.treesitter"))

		-- Text objects based on syntax trees!!
		use("nvim-treesitter/nvim-treesitter-textobjects")

		-- Highlight definition of current symbol, current scope
		use("nvim-treesitter/nvim-treesitter-refactor")

		-- Disabled because it's erroring out on ruby
		-- use 'romgrk/nvim-treesitter-context' -- Show "code breadcrumbs"
		use(require("pconfig.gps")) -- Shows syntactical context in status bar.

		-- Debugging/REPLs
		use(require("pconfig.dap"))
		use(require("pconfig.dap_ui"))

		-- use({
		-- 	"theHamsta/nvim-dap-virtual-text",
		-- 	ft = dap_enabled_filetypes,
		-- 	requires = "mfussenegger/nvim-dap",
		-- 	config = function()
		-- 		require("nvim-dap-virtual-text").setup({})
		-- 	end,
		-- })

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
		use(require("pconfig.octo"))

		use(require("pconfig.gitlinker"))

		-- Misc
		use("tpope/vim-commentary") -- (Un)comment stuff with gc
		use(require("pconfig.which_key")) -- show candidate mappings after pressing a key

		-- A quick-and-dirty solution to typing Amharic in vim,
		-- without having to rely on changing the system-wide keyboard layout
		use(require("pconfig.amharic"))

		-- JSX
		-- CSS / web dev
		-- use("maxmellon/vim-jsx-pretty") -- I hope this fixes indentation for jSX until TreeSitter supports JSX.
		use(require("pconfig.ts_autotag")) -- When changing tags, change both
		use(require("pconfig.colorizer"))
		-- Used currently for editing JSX mostly
		use({ "tpope/vim-surround" })
		--  CUrrently used for reapting the things I do with vim-surround
		use({ "tpope/vim-repeat" })

		-- Markdown
		use({ "plasticboy/vim-markdown", ft = { "markdown" } })
		use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", ft = { "markdown" } })
		use({ "dhruvasagar/vim-table-mode", ft = { "markdown" } })
    use({ "dkarter/bullets.vim", ft = { "markdown" }})

		-- Testing things
		use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })

		-- FYI, dispatch.vim is not a strict requirement, but it's nicer.
		use(require("pconfig.test"))

		-- Let's see how much better this is.
		use(require("pconfig.ultest"))

		-- Improved definition of the "word" text object.
		use("chaoren/vim-wordmotion")

		-- Tex
		--use { 'lervag/vimtex',  ft = { 'tex' } }

		-- Colors and other niceties
		use(require("pconfig.zen_mode"))

		use(require("pconfig.web_devicons"))

		use("Mofiqul/vscode.nvim")
		use(require("pconfig.lualine"))

		-- Capture output of ex commands (slightly quicker than doing :redir /tmp/SOMEFILE | the_ex_command | redir END)
		use(require("pconfig.capture"))

		-- A "buffer" line. (like tabs, but buffers, and on top)
		use(require("pconfig.bufferline"))

		-- Clipboard manager.
		use(require("pconfig.neoclip"))

		-- Telescope file browser.
		use(require("pconfig.telescope_file_browser"))

		-- Indicate LSP progress
		use(require("pconfig.fidget"))

		-- vim-matchup
		use(require("pconfig.matchup"))

		use(require("pconfig.telescope_fzf_native"))
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
