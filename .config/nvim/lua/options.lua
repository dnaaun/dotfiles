--- when I use neovim as a pager, and then asynchronously load everything else later.
--- Having a file with just options (more or less)  is helpful because I can source it earlier

opt = vim.opt
--- not filetype-specific, or plugin-specific
opt.number = true
-- Prevent weird (de-)endentation when writing python/orgmode.
opt.indentkeys:remove({ ":" })
opt.indentkeys:remove({ "<:>" })

opt.matchpairs:append({ "<:>" })
opt.scrollback = 100000 -- Lines to keep in neovim's terminal emulator
opt.spell = false
opt.conceallevel = 2 -- for neorg to hide links right now.
opt.splitbelow = true
opt.splitright = true
opt.hlsearch = true
opt.incsearch = true -- Incremental search highlight
opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }
-- Enable backspace on everything
opt.backspace = { "indent", "eol", "start" }
opt.mouse = "a" -- Resize vim splists with a mouse when inside tmux
opt.colorcolumn:append({ "+1" }) -- Draw a line at wrapwidth
opt.grepprg = "rg -nH" -- Use ripgrep as a grep program

-- Less verbose notifications (especailly now that I'm using nvim-notify/noice).
opt.shortmess:append("s") -- don't give "search hit BOTTOM, continuing at TOP", etc, messages.
opt.shortmess:append("W") -- don't give "written" or "[w]" when writing a file
opt.shortmess:append("F") -- don't tell me about newly opened files

-- https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/, mostly.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 6
opt.foldenable = true
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Save space
opt.foldcolumn = "1"

opt.signcolumn = "yes:1"

-- Have one global status line
opt.laststatus = 3
-- Have a thin line separating the splits
vim.cmd([[highlight WinSeparator guifg=None guifg=#aaa]])

local g = vim.g

g.loaded_matchparen = 1
g.loaded_matchit = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_tarPlugin = 1
g.loaded_man = 1
g.loaded_gzip = 1
g.loaded_zipPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_shada_plugin = 1
g.loaded_spellfile_plugin = 1
-- let g:loaded_netrw             = 1
-- let g:loaded_netrwPlugin       = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_remote_plugins = 1

-- _G.lsp_config_on_attach_callbacks = {}

g.mapleader = ","
g.maplocalleader = ","


