-- Tree-sitter https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        --disable = { 'javascriptreact', 'jsx', 'javascript.jsx' } 
    },
    indent = {
        enable = true,
        disable = { 'javascriptreact', 'jsx', 'javascript.jsx' } 
    },
    incremental_selection = {
      enable = true,
        disable = { 'javascriptreact', 'jsx', 'javascript.jsx' } 
    }
}
