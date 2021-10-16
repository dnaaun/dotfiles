mapfunc = require("std2").mapfunc
nvim_set_keymap = vim.api.nvim_set_keymap
nvim_command = vim.api.nvim_command

---- not plugin-specific login ----
vim.opt.number = true
-- Prevent wierd de-endentation when writing python
vim.opt.indentkeys:remove({":"})

vim.opt.matchpairs:append({"<:>"})
vim.opt.scrollback=100000 -- Lines to keep in neovim's terminal emulator
vim.opt.spell=false
vim.opt.conceallevel=0
vim.opt.splitbelow=true
vim.opt.splitright=true
vim.opt.hlsearch=true
vim.opt.incsearch=true -- Incremental search highlight
vim.opt.completeopt={"menuone","noselect"}
-- Enable backspace on everything
vim.opt.backspace={"indent", "eol", "start"}
vim.opt.mouse="a" -- Resize vim splists with a mouse when inside tmux
vim.opt.colorcolumn:append({"+1"}) -- Draw a line at wrapwidth
vim.opt.grepprg='rg -nH' -- Use ripgrep as a grep program

vim.g.mapleader=","
vim.g.maplocalleader = ","

-- Copied from / inspired by tpope/unimpaired.vim
nvim_set_keymap("n", "<Leader>qo", ":copen<CR>", {})
nvim_set_keymap("n", "<Leader>qc", ":cclose<CR>", {})
nvim_set_keymap("n", "]q", ":cnext<CR>", {})
nvim_set_keymap("n", "[q", ":cprev<CR>", {})

-- Same pattern for loclist
nvim_set_keymap("n", "<Leader>lo", ":lopen<CR>", {})
nvim_set_keymap("n", "<Leader>lc", ":lclose<CR>", {})
-- cr stands for 'config reload'
mapfunc("n", "<Leader>cr", require('nvim-reload').Reload, {})


-- WHen in visual/select/operator mode, I want searching with / to be an inclusive
-- motion. This is acheived by doing /pattern/e, but I don't wanna have to type
-- that /e everytime so:
nvim_set_keymap("v", "/", "//e<Left><Left>", {})
nvim_set_keymap("o",  "/",  "//e<Left><Left>", {})

-- ]s means go to next spelling error.
nvim_set_keymap("n",  "<Leader>s", "]s1z=<C-X><C-S>", {})
-- https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
-- Insert mode, correct last error.
nvim_set_keymap("i", "<C-v>", "<Esc>[s1z=``a", {})

-- A hack to avoid having press a key before the terminal closes when the process in the
-- terminal finishes.
nvim_command("autocmd TermClose * call feedkeys('x')")

vim.g.python3_host_prog=vim.fn.substitute(vim.fn.system("which python3"), "\n", '', 'g')

---- Add plugins ----
require('plugins')


---- Colorscheme ----
-- This section must come before loading nvim-dap for it not to mess up
-- nvim-dap colors.
-- checks if your terminal has 24-bit color support
if vim.fn.has("termguicolors") then
    vim.g.tokyonight_style='storm'
    nvim_command("colorscheme tokyonight")
    vim.opt.termguicolors = true
    nvim_command("highlight LineNr ctermbg=NONE guibg=NONE")
else
  nvim_command("colorscheme base16-snazzy")
end

---- Lua plugin configuration separated out to files ----
-- Need to source lsp_config last because we collect some callbacks
-- from other plugin configs that are needed to set it up. Namely:
_G.lsp_config_on_attach_callbacks = {}
for filename in io.popen('ls ~/.config/nvim/lua/plugin_config'):lines() do
    local module_name = string.gsub(filename, "%.lua$", "")
    if module_name ~= "lsp_config" then
        require("plugin_config."..module_name)
    end
end

require("plugin_config.lsp_config")


---- vim-tmux-navigator ----
-- I bring this after the plugins sections because I haven't yet figured
-- out how to turn of conflicting keybinds from coq.nvim
nvim_set_keymap("v", "<C-j>", "<cmd>:TmuxNavigateDown<CR>", {noremap=true})
nvim_set_keymap("v", "<C-k>", "<cmd>:TmuxNavigateUp<CR>", {noremap=true})
nvim_set_keymap("v", "<C-h>", "<cmd>:TmuxNavigateLeft<CR>", {noremap=true})
nvim_set_keymap("v", "<C-l>", "<cmd>:TmuxNavigateRight<CR>", {noremap=true})

nvim_set_keymap("n", "<C-j>", "<cmd>:TmuxNavigateDown<CR>", {noremap=true})
nvim_set_keymap("n", "<C-k>", "<cmd>:TmuxNavigateUp<CR>", {noremap=true})
nvim_set_keymap("n", "<C-h>", "<cmd>:TmuxNavigateLeft<CR>", {noremap=true})
nvim_set_keymap("n", "<C-l>", "<cmd>:TmuxNavigateRight<CR>", {noremap=true})

nvim_set_keymap("i", "<C-j>", "<cmd>:TmuxNavigateDown<CR>", {noremap=true})
nvim_set_keymap("i", "<C-k>", "<cmd>:TmuxNavigateUp<CR>", {noremap=true})
nvim_set_keymap("i", "<C-h>", "<cmd>:TmuxNavigateLeft<CR>", {noremap=true})
nvim_set_keymap("i", "<C-l>", "<cmd>:TmuxNavigateRight<CR>", {noremap=true})

-- Repeat same mappings for terminal mode in neovim
nvim_set_keymap("t", "<C-j>", "<cmd>:TmuxNavigateDown<CR>", {noremap=true})
nvim_set_keymap("t", "<C-k>", "<cmd>:TmuxNavigateUp<CR>", {noremap=true})
nvim_set_keymap("t", "<C-h>", "<cmd>:TmuxNavigateLeft<CR>", {noremap=true})
nvim_set_keymap("t", "<C-l>", "<cmd>:TmuxNavigateRight<CR>", {noremap=true})

---- himalaya ----
vim.g.himalaya_mailbox_picker= 'telescope'
vim.g.himalaya_telescope_preview_enabled = 0
-- packer has issues with loading rtp: https://github.com/wbthomason/packer.nvim/issues/274
vim.opt.rtp = vim.o.rtp .. ',' .. vim.fn.stdpath('data') .. '/site/pack/packer/start/himalaya/vim/'

---- zen-mode ----
nvim_set_keymap("n", "<silent>", "<leader>v :ZenMode<CR>", {noremap=true})


---- packer  ----
-- TODO: Move this section to plugins.lua
-- Make it quicker to install plugins
nvim_command("autocmd FileType vim,lua nnoremap <buffer> <leader>ci :source %<bar>PackerInstall<CR>")
-- Sometimes I just wanna load the current file
nvim_command("autocmd FileType vim,lua nnoremap <buffer> <leader>cc :source %<CR>")


---- vimtex ----
---- Vimtex settings
vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='skim'
vim.g.vimtex_quickfix_ignore_filters = { '\v(Under|Over)full \\(h|v)box'} -- Ignore some latex 'errors'
vim.g.vimtex_quickfix_open_on_warning=0


---- lnvimrc.vim ----
---- Local vimrc
vim.g.localvimrc_debug=1
vim.g.localvimrc_name={'.lnvimrc'}
-- Whitelist everything in home directory
-- https://stackoverflow.com/a/48519356
vim.g.localvimrc_whitelist = { vim.fn.fnamemodify('~', ':p') }
-- Disable "sandbox" mode
vim.g.localvimrc_sandbox=0



---- vim-airline ----
-- Status line theme is whatever base16 theme I am using
-- let g:airline_theme='base16'
vim.g.airline_theme='base16_snazzy'
-- No error messages about whitespaces please
vim.g["airline#extensions#whitespace#enabled"] = 0

-- Without this, airline truncates the filename instead of the git branch when 
-- space gets tight
vim.g["airline#extensions#default#section_truncate_width"] = {
      b= 79,
      x= 60,
      y= 88,
      z= 45,
      warning= 80,
      error= 80
      }

---- vim-markdown ----
-- Markdown fenced languages support
-- https://github.com/plasticboy/vim-markdown/commit/04e060dc062ee981f5c9bcc8f3b700f803da285f
vim.g.vim_markdown_fenced_languages = {'json', 'bash', 'tsx=typescriptreact', 'lua'}
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 0
---- Markdown, make preview available remotely (ie, serve on 0.0.0.0, not localhost)
vim.g.mkdp_open_to_the_world = 1
vim.api.nvim_exec([[
augroup MarkdownRelated
    au!
	au FileType markdown nmap <Leader>m <Plug>MarkdownPreviewToggle<CR>
augroup END
]], false)


---- fugitive.vim ----
nvim_set_keymap("n", "<Leader>gs", ":Git!<CR>", {noremap=true})
nvim_set_keymap("n", "<Leader>gd", ":Gdiffsplit<CR>", {noremap=true})
nvim_set_keymap("n", "<Leader>gc", ":Git commit<CR>", {noremap=true})
nvim_set_keymap("n", "<Leader>gl", ":Glog<CR>", {noremap=true})
nvim_set_keymap("n", "<Leader>gw", ":Gwrite<CR>", {noremap=true})
nvim_set_keymap("n", "<Leader>gr", ":Gpull --rebase<CR>", {noremap=true})
nvim_set_keymap("n", "<Leader>gp", ":Gpush<CR>", {noremap=true})
nvim_set_keymap("n", "<Leader>gg", ":Git ", {noremap=true})


---- netrw ----
vim.g.netrw_localrmdir='rm -r' -- Allow netrw to remove non-empty local directories
vim.g.netrw_keepdir=1 -- Make netrw moving work
vim.g.netrw_sort_by='time' -- Netrw sort by time in descending order
vim.g.netrw_sort_direction='reverse'


---- indent-blankline ----
vim.g.indent_blankline_buftype_exclude = {'terminal'}


---- dap-virtual-text ----
vim.g.dap_virtual_text = 'all frames'


---- Secondary init file ----
-- Include a "secondary" init file that is machine-specific (ie, not racked in this repo)
local secondary_init_vim=vim.fn.expand('~/.secondary.init.lua')
if vim.fn.filereadable(secondary_init_vim) == true then
    nvim_command('source ' .. secondary_init_vim)
end

---- Firenvim!
print('asdfsdfasdfasdfasdfKERJER')
if vim.fn.exists('g:started_by_firenvim') then
  vim.opt.guifont='monospace:h16'
end
