require('impatient') -- Speed up loading things. TOFIXLATER: This will probably (definitely?) break when impatient.nvim is not installed.

local g = vim.g
local opt = vim.opt

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
-- let g:loaded_remote_plugins    = 1

_G.lsp_config_on_attach_callbacks = {}

local nvim_set_keymap = vim.api.nvim_set_keymap

--- not filetype-specific, or plugin-specific
opt.number = true
-- Prevent wierd de-endentation when writing python
opt.indentkeys:remove({ ":" })

opt.fillchars = opt.fillchars + "diff:╱"

opt.matchpairs:append({ "<:>" })
opt.scrollback = 100000 -- Lines to keep in neovim's terminal emulator
opt.spell = false
opt.conceallevel = 0
opt.splitbelow = true
opt.splitright = true
opt.hlsearch = true
opt.incsearch = true -- Incremental search highlight
opt.completeopt = { "menuone", "noselect" }
-- Enable backspace on everything
opt.backspace = { "indent", "eol", "start" }
opt.mouse = "a" -- Resize vim splists with a mouse when inside tmux
opt.colorcolumn:append({ "+1" }) -- Draw a line at wrapwidth
opt.grepprg = "rg -nH" -- Use ripgrep as a grep program

g.mapleader = ","
g.maplocalleader = ","

-- Quickfix shortcuts
nvim_set_keymap("n", "<leader>qo", ":copen<CR>", {})
nvim_set_keymap("n", "]q", ":cnext<CR>", {})
nvim_set_keymap("n", "[q", ":cprev<CR>", {})

-- WHen in visual/select/operator mode, I want searching with / to be an inclusive
-- motion. This is acheived by doing /pattern/e, but I don't wanna have to type
-- that /e everytime so:
nvim_set_keymap("v", "/", "//e<Left><Left>", {})
nvim_set_keymap("o", "/", "//e<Left><Left>", {})

-- ]s means go to next spelling error.
nvim_set_keymap("n", "<Leader>s", "]s1z=<C-X><C-S>", {})
-- https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
-- Insert mode, correct last error.
nvim_set_keymap("i", "<C-v>", "<Esc>[s1z=``a", {})

-- A hack to avoid having press a key before the terminal closes when the process in the
-- terminal finishes.
-- vim.nvim_command("autocmd TermClose * call feedkeys('x')")

g.python3_host_prog = vim.fn.substitute(vim.fn.system("which python3"), "\n", "", "g")

---- Add plugins ----
require("plugins")

-- This section must come before loading nvim-dap for it not to mess up
-- nvim-dap colors.
-- checks if your terminal has 24-bit color support
-- g.tokyonight_style = "day"
-- g.snazzybuddy_icons = true
g.vscode_style = "dark"
vim.cmd("colorscheme vscode")

---- vim-tmux-navigator ----
-- I bring this after the plugins sections because I haven't yet figured
-- out how to turn of conflicting keybinds from coq.nvim
---- lnvimrc.vim ----
---- Local vimrc
g.localvimrc_debug = 1
g.localvimrc_name = { ".lnvimrc" }
-- Whitelist everything in home directory
-- https://stackoverflow.com/a/48519356
g.localvimrc_whitelist = { vim.fn.fnamemodify("~", ":p") }
-- Disable "sandbox" mode
g.localvimrc_sandbox = 0
