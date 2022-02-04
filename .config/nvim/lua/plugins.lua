require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim") -- package/plugin manager
		use({
			"glacambre/firenvim",
			run = function()
				vim.fn["firenvim#install"](0)
			end,
		})

		-- Colors and other niceties
		use("vim-airline/vim-airline")
		use({ "folke/zen-mode.nvim", branch = "main" })
		use("kyazdani42/nvim-web-devicons")
		use("vim-airline/vim-airline-themes")
		use("christoomey/vim-tmux-navigator")
		use("folke/tokyonight.nvim") -- colorscheme
		use("joshdick/onedark.vim") -- colorscheme
    use 'tjdevries/colorbuddy.nvim'
    use( { 'bbenzikry/snazzybuddy.nvim', requires = "tjdevries/snazzybuddy.nvim" } )
		use({ "lukas-reineke/indent-blankline.nvim" })
    use 'luukvbaal/stabilize.nvim' -- WHen opening splits, let the remaining one remain "stable"


		-- Markdown
		use({ "plasticboy/vim-markdown", ft = { "markdown" } })
		use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })
		use({ "dhruvasagar/vim-table-mode", ft = { "markdown" } })

		-- Tex
		--use { 'lervag/vimtex',  ft = { 'tex' } }

		use("embear/vim-localvimrc") -- Enable sourcing .lnvimrc files
		use("sedm0784/vim-resize-mode") -- After doing <C-w>,  be able to type consecutive +,-,<,>

		-- LSP dependent/related
		use("neovim/nvim-lspconfig") -- Configure neovim's builtin LSP client easier
		use("nvim-lua/lsp_extensions.nvim") -- TODO: Setup inlay hints for rust, or just fix rust-tools.nvim's inlay hints
		use("kosayoda/nvim-lightbulb")
		use("folke/lua-dev.nvim") -- Provides type annotations for neovim's Lua interface. Needs Sumenkos' Lua LSP. TODO: Not actually set up yet: https://github.com/folke/lua-dev.nvim#%EF%B8%8F--configuration
		use({"ray-x/lsp_signature.nvim", ft = { "rust" } }) -- Show func signatures automatically
		use("~/git/coq_nvim") -- Super fast, super feature complete, completion plugin
		use("ms-jpq/coq.thirdparty") -- Non standard and third party sources for coq
		use("stevearc/aerial.nvim") -- Symbol tree. Better than symbols-outline.nvim because it allows filtering by symbol type.

		-- Tree sitter
		use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- Do highlighting, indenting, based on ASTs
		use("nvim-treesitter/nvim-treesitter-textobjects") -- Text objects based on syntax trees!!
		use("nvim-treesitter/nvim-treesitter-refactor") -- Highlight definition of current symbol, current scope
		-- Disabled because it's erroring out on ruby
		-- use 'romgrk/nvim-treesitter-context' -- Show "code breadcrumbs"
		use({ "SmiteshP/nvim-gps", requires = "nvim-treesitter/nvim-treesitter" }) -- Shows syntactical context in status bar.

		-- Debugging/REPLs
		use("~/git/nvim-dap")
		use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
		use("theHamsta/nvim-dap-virtual-text")
		use("hkupty/iron.nvim") -- Spin up a repl in a neovim terminal and send text to it
		use("famiu/nvim-reload") -- Adds :Reload and :Restart to make reloading lua easier
		use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } }) -- Turn good ol' linters and formattesr as an LSP.

		-- JSX
		use("maxmellon/vim-jsx-pretty") -- I hope this fixes indentation for jSX until TreeSitter supports JSX.
		use("windwp/nvim-ts-autotag") -- When changing tags, change both
		use("andymass/vim-matchup") -- Does more than highlight matching tags. But that's what I use it for.

		-- (Fuzzy) search everything!
		use("nvim-lua/plenary.nvim") -- The unofficial standard library for neovim plugins.
		use("nvim-lua/popup.nvim") -- Umm, dunno actually.
		use("nvim-telescope/telescope.nvim")
		use({ "nvim-telescope/telescope-fzf-native.nvim", branch = "main", run = "make" })

		-- Misc
		use("tpope/vim-vinegar") -- Make netrw better. What I for sure know I use from this is the - mapping to go up a directory.
		use("machakann/vim-sandwich") -- Surround textobjects with {(<p>"'
		use("tpope/vim-commentary") -- (Un)comment stuff with gc
		use("folke/which-key.nvim") -- show candidate mappings after pressing a key
		use("Shatur/neovim-session-manager") -- Save sessions by directory

		-- Git and Github
		use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }) -- Look at lines added/modified/taken away, all at a glance.
		use({ "tpope/vim-fugitive", requires = { "nvim-lua/plenary.nvim" } }) -- And I quote tpope, "A git plugin so awesome, it should be illegal."
		use({ "tpope/vim-rhubarb" })
		use({ "pwntester/octo.nvim", requires = { "kyazdani42/nvim-web-devicons" } }) -- Who needs web interfaces when you have neovim interfaces (for Github)?

		-- Kotlin
		use({ "udalov/kotlin-vim" })
		-- Rust
		use("simrat39/rust-tools.nvim")

		-- A quick-and-dirty solution to typing Amharic in vim,
		-- without having to rely on changing the system-wide keyboard layout
		use("davidatbu/amharic.nvim")

		-- Life planning
		use({
			"nvim-neorg/neorg",
			requires = "nvim-lua/plenary.nvim",
		})

		-- Testing things
		use("tpope/vim-dispatch") -- I use it for vim-test
		use({ "vim-test/vim-test", requires = { "tpope/vim-dispatch" } }) -- FYI, dispatch.vim is not a strict requirement, but it's nicer.

		use("crivotz/nvim-colorizer.lua") -- If you're reading this in nvim, #0ED should be highlighted with light blue. Thank you nvim-colorizer.


    use 'nacro90/numb.nvim' -- Preview lines by doing :LINENUM, like :23 to look around line 23

    -- Improved definition of the "word" text object.
    use 'chaoren/vim-wordmotion'

    -- Explore databases from nvim
    use { 'dinhhuy258/vim-database', branch='master', run=':UpdateRemotePlugins'}

	end,

	config = {
		git = {
			clone_timeout = 1800, -- 30 minutes
		},
	},
})
