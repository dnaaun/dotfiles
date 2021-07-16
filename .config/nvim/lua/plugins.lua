return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'mhartington/oceanic-next'
    use 'christoomey/vim-tmux-navigator'

    use 'embear/vim-localvimrc' -- Enable sourcing .lnvimrc files
    use 'sedm0784/vim-resize-mode' -- After doing <C-w>,  be able to type consecutive +,-,<,>
    
    -- Mostly LSP dependent
    use 'neovim/nvim-lspconfig' -- Neovim's builtin LSP client
    use { 'glepnir/lspsaga.nvim', { branch = 'main'} } -- A --light-weight lsp plugin--
    use 'ray-x/lsp_signature.nvim' -- Show func signatures automatically
    use 'hrsh7th/nvim-compe' -- Auto completion for neovim
    use { 'folke/trouble.nvim', { branch = 'main'} } -- Basically a slightly nicer loclist that works well with Neovim's LSP and Telescope

    -- Tree sitter
    use 'nvim-treesitter/nvim-treesitter' -- Do highlighting, indenting, based on ASTs
    use 'nvim-treesitter/nvim-treesitter-textobjects' -- Text objects based on syntax trees!!


    use '~/git/nvim-repl'
    use 'famiu/nvim-reload' -- Adds :Reload and :Restart to make reloading lua easier
    use 'mhartington/formatter.nvim' -- Replace ALE's formatting
    use 'mfussenegger/nvim-dap' -- TODO: Set this up to replace vim-ripple.

    -- JSX
    use 'maxmellon/vim-jsx-pretty' -- I hope this fixes indentation for jSX until TreeSitter supports JSX.
    use 'AndrewRadev/tagalong.vim' -- When changing tags, change both

    -- Python
    use { 'vim-test/vim-test', { ft = {'python'} } } -- run tests easily
    use { 'tpope/vim-dispatch', { ft = {'python'} } } -- Here only cuz vim-test


    -- (Fuzzy) search everything!
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    -- TODO: Run `make` after install
    use { 'nvim-telescope/telescope-fzf-native.nvim', branch = 'main' }


    use 'tpope/vim-unimpaired'  -- TPope makes vim sane
    use 'tpope/vim-vinegar' -- Better netrw
    use 'tpope/vim-fugitive' -- Git
    use 'tpope/vim-obsession' -- Session management
    use 'tpope/vim-repeat' -- nvim-repl (and probably others) depend on / support this (it allows for repeating with . plugin-defined 'actions')

    -- CSS
    use { 'ap/vim-css-color',  ft = 'css'  } -- Highlight css colors

    -- Writing
    -- Markdown
    use { 'plasticboy/vim-markdown',  ft = 'markdown' }

    -- Tex
    use { 'lervag/vimtex',  ft = 'tex' }
    use {'KeitaNakamura/tex-conceal.vim', ft = 'tex' }
    -- Ultisnips's neovim support is 'on a best effort basis'
    -- https://github.com/SirVer/ultisnips/issues/801
    -- use 'SirVer/ultisnips', { ft = {'tex'}, 'commit': '96026a4df27899b9e4029dd3b2977ad2ed819caf' } 
    use 'hrsh7th/vim-vsnip' 
    
    -- Colors and other niceties
    -- Breaks when I do :Reload
    use 'vim-airline/vim-airline'
    use { 'folke/zen-mode.nvim',  branch = 'main' }
    use 'kyazdani42/nvim-web-devicons'
end
)


