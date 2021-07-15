-- Tree-sitter https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        --disable = { 'javascriptreact', 'jsx', 'javascript.jsx' } 
    },
    indent = {
        enable = true,
        disable = {'python'} 
    },
    incremental_selection = {
      enable = true,
         -- disable = { 'javascriptreact', 'jsx', 'javascript.jsx' } 
    }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "jsx", "javascript.jsx", "javascriptreact" }
