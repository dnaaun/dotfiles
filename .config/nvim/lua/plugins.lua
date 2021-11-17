require('packer').startup {
  function(use)
    use 'wbthomason/packer.nvim' -- package/plugin manager
    use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
}
    use 'vim-airline/vim-airline-themes'
    use 'christoomey/vim-tmux-navigator'
    use 'folke/tokyonight.nvim' -- colorscheme
    use 'chriskempson/base16-vim'
    use { "lukas-reineke/indent-blankline.nvim", ft = { 'html', 'htmldjango', 'python' } }

    use { 'plasticboy/vim-markdown',  ft = { 'markdown' } }
    use { 'iamcco/markdown-preview.nvim', ft = { 'markdown' }, run='cd app && npm install'  }
    use({ 'dhruvasagar/vim-table-mode', ft = { 'markdown' } })

    -- Tex
    --use { 'lervag/vimtex',  ft = { 'tex' } }

    use 'embear/vim-localvimrc' -- Enable sourcing .lnvimrc files
    use 'sedm0784/vim-resize-mode' -- After doing <C-w>,  be able to type consecutive +,-,<,>

    -- LSP dependent/related
    use 'neovim/nvim-lspconfig' -- Configure neovim's builtin LSP client easier
    use 'nvim-lua/lsp_extensions.nvim' -- TODO: Setup inlay hints for rust, or just fix rust-tools.nvim's inlay hints
    use 'kosayoda/nvim-lightbulb'
    use 'folke/lua-dev.nvim' -- Provides type annotations for neovim's Lua interface. Needs Sumenkos' Lua LSP. TODO: Not actually set up yet: https://github.com/folke/lua-dev.nvim#%EF%B8%8F--configuration
    --use 'ray-x/lsp_signature.nvim' -- Show func signatures automatically
    use '~/git/coq_nvim'  -- Super fast, super feature complete, completion plugin
    use 'ms-jpq/coq.thirdparty' -- Non standard and third party sources for coq
    use 'stevearc/aerial.nvim' -- Symbol tree. Better than symbols-outline.nvim because it allows filtering by symbol type.

    -- Tree sitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Do highlighting, indenting, based on ASTs
    use 'nvim-treesitter/nvim-treesitter-textobjects' -- Text objects based on syntax trees!!
    use 'nvim-treesitter/nvim-treesitter-refactor' -- Highlight definition of current symbol, current scope

    -- Disabled because it's erroring out on ruby
    -- use 'romgrk/nvim-treesitter-context' -- Show "code breadcrumbs"


    -- Debugging/REPLs
    use '~/git/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'hkupty/iron.nvim' -- Spin up a repl in a neovim terminal and send text to it
    use 'famiu/nvim-reload' -- Adds :Reload and :Restart to make reloading lua easier
    use {'jose-elias-alvarez/null-ls.nvim', requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } } -- Turn good ol' linters and formattesr as an LSP. Preferred over efm-langserver because it supports range formatting

    -- JSX
    use 'maxmellon/vim-jsx-pretty' -- I hope this fixes indentation for jSX until TreeSitter supports JSX.
    use 'windwp/nvim-ts-autotag' -- When changing tags, change both


    -- (Fuzzy) search everything!
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'nvim-telescope/telescope.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', branch = 'main', run = 'make' }



    -- Misc
    use 'tpope/vim-vinegar' -- Make netrw better. What I for sure know I use from this is the - mapping to go up a directory.
    use 'machakann/vim-sandwich' -- Surround textobjects with {(<p>"'
    use 'tpope/vim-commentary' -- (Un)comment stuff with gc
    use 'folke/which-key.nvim' -- show candidate mappings after pressing a key
    use 'Shatur/neovim-session-manager' -- Save sessions by directory


    -- Git and Github
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- Look at lines added/modified/taken away, all at a glance.
    use { 'tpope/vim-fugitive', requires = { 'nvim-lua/plenary.nvim' } } -- And I quote tpope, "A git plugin so awesome, it should be illegal."
    use { 'tpope/vim-rhubarb' }
    use { 'pwntester/octo.nvim', requires = { 'kyazdani42/nvim-web-devicons' } } -- Who needs web interfaces when you have neovim interfaces (for Github)?

    -- Colors and other niceties
    use 'vim-airline/vim-airline'
    use { 'folke/zen-mode.nvim',  branch = 'main' }
    use 'kyazdani42/nvim-web-devicons'

    -- Kotlin
    use { 'udalov/kotlin-vim' }
    -- Rust
    use 'simrat39/rust-tools.nvim'


    -- A quick-and-dirty solution to typing Amharic in vim,
    -- without having to rely on changing the system-wide keyboard layout
    use 'davidatbu/amharic.nvim'


    -- SQL autocompletion. Sadly, not an LSP, needed for default sql omnifunc. But will do.
    use 'vim-scripts/dbext.vim'
  end
  ,

  config = {
    git = {
      clone_timeout = 1800 -- 30 minutes
    }
  }
}
