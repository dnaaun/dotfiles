return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'vim-airline/vim-airline-themes'
    use 'christianchiarulli/nvcode-color-schemes.vim'
    use 'christoomey/vim-tmux-navigator'
    use { "lukas-reineke/indent-blankline.nvim", ft = { 'html', 'htmldjango' } }


    use 'embear/vim-localvimrc' -- Enable sourcing .lnvimrc files
    use 'sedm0784/vim-resize-mode' -- After doing <C-w>,  be able to type consecutive +,-,<,>

    -- Mostly LSP dependent
    use 'neovim/nvim-lspconfig' -- Neovim's builtin LSP client
    use 'kabouzeid/nvim-lspinstall' -- Easily (and if desired, automatically) install LSPs
    use 'nvim-lua/lsp_extensions.nvim'

    use 'ray-x/lsp_signature.nvim' -- Show func signatures automatically
    use 'hrsh7th/nvim-compe' -- Auto completion for neovim
    use 'folke/trouble.nvim' -- Basically a slightly nicer loclist that works well with Neovim's LSP and Telescope
    use 'stevearc/aerial.nvim' -- Symbol tree. Better than symbols-outline.nvim because it allows filtering by symbol type.

    -- Tree sitter
    use 'nvim-treesitter/nvim-treesitter' -- Do highlighting, indenting, based on ASTs
    use 'nvim-treesitter/nvim-treesitter-textobjects' -- Text objects based on syntax trees!!

    -- Debugger
    use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'theHamsta/nvim-dap-virtual-text'


    use 'hkupty/iron.nvim' -- Spin up a repl in a neovim terminal and send text to it
    use 'famiu/nvim-reload' -- Adds :Reload and :Restart to make reloading lua easier
    use 'mhartington/formatter.nvim' -- Replace ALE's formatting

    -- JSX
    use 'maxmellon/vim-jsx-pretty' -- I hope this fixes indentation for jSX until TreeSitter supports JSX.
    use 'AndrewRadev/tagalong.vim' -- When changing tags, change both



    -- (Fuzzy) search everything!
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'nvim-telescope/telescope.nvim'
    -- TODO: Run `make` after install
    use { 'nvim-telescope/telescope-fzf-native.nvim', branch = 'main' }


    use 'tpope/vim-unimpaired'  -- TPope makes vim sane
    use 'tpope/vim-vinegar' -- Better netrw
    use 'tpope/vim-fugitive' -- Git
    use 'tpope/vim-obsession' -- Session management
    use 'machakann/vim-sandwich' -- Surround textobjects with {(<p>"' 
    use 'tpope/vim-commentary' -- *Un)comment stuff with gc


    -- Writing
    -- Markdown
    use { 'plasticboy/vim-markdown',  ft = 'markdown' }

    -- Tex
    use { 'lervag/vimtex',  ft = { 'tex' } }
    use {'KeitaNakamura/tex-conceal.vim', ft = 'tex' }
    -- Ultisnips's neovim support is 'on a best effort basis'
    -- https://github.com/SirVer/ultisnips/issues/801
    use { 'SirVer/ultisnips'}

    -- Colors and other niceties
    -- Breaks when I do :Reload
    use 'vim-airline/vim-airline'
    use { 'folke/zen-mode.nvim',  branch = 'main' }
    use 'kyazdani42/nvim-web-devicons'

    use { 'udalov/kotlin-vim' }
end
)
