return require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim' -- package/plugin manager
    use 'vim-airline/vim-airline-themes'
    use 'christoomey/vim-tmux-navigator'
    use 'folke/tokyonight.nvim' -- colorscheme
    use { "lukas-reineke/indent-blankline.nvim", ft = { 'html', 'htmldjango', 'python' } }


    use 'embear/vim-localvimrc' -- Enable sourcing .lnvimrc files
    use 'sedm0784/vim-resize-mode' -- After doing <C-w>,  be able to type consecutive +,-,<,>

    -- LSP dependent/related
    use 'neovim/nvim-lspconfig' -- Configure neovim's builtin LSP client easier
    use 'nvim-lua/lsp_extensions.nvim' -- TODO: Setup inlay hints for rust, or just fix rust-tools.nvim's inlay hints
    use 'kosayoda/nvim-lightbulb'
    use 'folke/lua-dev.nvim' -- Provides type annotations for neovim's Lua interface. Needs Sumenkos' Lua LSP. TODO: Not actually set up yet: https://github.com/folke/lua-dev.nvim#%EF%B8%8F--configuration
    use 'ray-x/lsp_signature.nvim' -- Show func signatures automatically
    use '~/git/coq_nvim'  -- Super fast, super feature complete, completion plugin
    use  '~/git/coq.artifacts' -- Snippets for coq_nvim
    use 'stevearc/aerial.nvim' -- Symbol tree. Better than symbols-outline.nvim because it allows filtering by symbol type.

    -- Tree sitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Do highlighting, indenting, based on ASTs
    use 'nvim-treesitter/nvim-treesitter-textobjects' -- Text objects based on syntax trees!!
    use 'nvim-treesitter/nvim-treesitter-refactor' -- Highlight definition of current symbol, current scope
    use 'romgrk/nvim-treesitter-context' -- Show "code breadcrumbs"


    -- Debugger
    use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'theHamsta/nvim-dap-virtual-text'


    use 'hkupty/iron.nvim' -- Spin up a repl in a neovim terminal and send text to it
    use 'famiu/nvim-reload' -- Adds :Reload and :Restart to make reloading lua easier
    use 'mhartington/formatter.nvim' -- Replace ALE's formatting

    -- JSX
    use 'maxmellon/vim-jsx-pretty' -- I hope this fixes indentation for jSX until TreeSitter supports JSX.
    use 'windwp/nvim-ts-autotag' -- When changing tags, change both


    -- (Fuzzy) search everything!
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'nvim-telescope/telescope.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', branch = 'main', run = 'make' }

    use {'ms-jpq/chadtree', branch='chad', run='python3 -m chadtree deps'}


    -- Superceded by ChadTree: use 'tpope/vim-vinegar' -- Make netrw better. What I for sure know I use from this is the - mapping to go up a directory.
    use 'tpope/vim-obsession' -- Session management
    use 'machakann/vim-sandwich' -- Surround textobjects with {(<p>"'
    use 'tpope/vim-commentary' -- *Un)comment stuff with gc

    -- Git and diffs
    use 'tpope/vim-fugitive' -- Git
    use 'airblade/vim-gitgutter' -- TODO: Setup.


    -- Writing
    -- Markdown
    use { 'plasticboy/vim-markdown',  ft = 'markdown' }

    -- Tex
    use { 'lervag/vimtex',  ft = { 'tex' } }
    --use {'KeitaNakamura/tex-conceal.vim', ft = 'tex' }
    -- Ultisnips's neovim support is 'on a best effort basis'
    -- https://github.com/SirVer/ultisnips/issues/801
    --use { 'SirVer/ultisnips'}

    -- Colors and other niceties
    -- Breaks when I do :Reload
    use 'vim-airline/vim-airline'
    use { 'folke/zen-mode.nvim',  branch = 'main' }
    use 'kyazdani42/nvim-web-devicons'

    -- Kotlin
    use { 'udalov/kotlin-vim' }

    -- Rust
    use 'simrat39/rust-tools.nvim'


    use '~/git/amharic.nvim'

    -- :MarkdownPreview
    use { 'iamcco/markdown-preview.nvim', run='cd app && npm install'  }

    -- SQL autocompletion. Sadly, not an LSP, needed for default sql omnifunc. But will do.
    use 'vim-scripts/dbext.vim'


  end,
  config = {
    git = {
      clone_timeout = 1800 -- 30 minutes
    }
  }
})
