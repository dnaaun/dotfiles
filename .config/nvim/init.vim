"""""""""""""""""""""" not plugin-specific login """""""""""""""""""""""
" Prevent wierd de-endentation when writing python
set indentkeys-=:

set scrollback=100000 " Lines to keep in neovim's terminal emulator
" Means I have to install pynvim in every venv, but makes life easier.
set foldexpr=
set nospell
set conceallevel=0
set splitbelow
set splitright
set nohlsearch " Don't higlight all matches
set incsearch " Incremental search highlight
" Add parenthesis to vaid filename chars for completion
set isfname+=(
set isfname+=)
set completeopt=menuone,noselect
" Enable backspace on everything
set backspace=indent,eol,start 
set mouse+=a " Resize vim splists with a mouse when inside tmux
set colorcolumn=+1 " Draw a line at wrapwidth
let &grepprg='rg -nH' " Use ripgrep as a grep program

let mapleader = ","
let maplocalleader = ","

" Copied from / inspired by tpope/unimpaired.vim
nnoremap <Leader>qo :copen<CR>
nnoremap <Leader>qc :cclose<CR>
nnoremap ]c :cnext<CR>
nnoremap [c :cprev<CR>

" Same pattern for loclist
nnoremap <Leader>lo :lopen<CR>
nnoremap <Leader>lc :lclose<CR>
" cr stands for 'config reload'
nnoremap <Leader>cr :Reload <CR>
" WHen in visual/select/operator mode, I want searching with / to be an inclusive
" motion. This is acheived by doing /pattern/e, but I don't wanna have to type
" that /e everytime so:
vnoremap / //e<Left><Left>
onoremap / //e<Left><Left>
" ]s means go to next spelling error.
nnoremap  <Leader>s ]s1z=<C-X><C-S>
" https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
" Insert mode, correct last error.
inoremap <C-v> <c-g>u<Esc>[s1z=`]a<c-g>u

" A hack to avoid having press a key before the terminal closes when the process in the
" terminal finishes.
autocmd TermClose * call feedkeys("x")

let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')

"""""""""""""""""""""""" Add plugins """""""""""""""""""""""""""""""
lua <<EOF
require('plugins')
EOF


""""""""""""""""""""""" Colorscheme """"""""""""""""""""""""""""""""""
" This section must come before loading nvim-dap for it not to mess up
" nvim-dap colors.
let g:tokyonight_style='storm'
colorscheme tokyonight
" checks if your terminal has 24-bit color support
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif



""""""""""""""" Lua plugin configuration separated out to files """"""""
lua <<EOF
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
EOF


"""""""""""""""""""" vim-tmux-navigator """""""""""""""""""""""""
" I bring this after the plugins sections because I haven't yet figured
" out how to turn of conflicting keybinds from coq.nvim
vnoremap <C-j> <cmd>:TmuxNavigateDown<CR>
vnoremap <C-k> <cmd>:TmuxNavigateUp<CR>
vnoremap <C-h> <cmd>:TmuxNavigateLeft<CR>
vnoremap <C-l> <cmd>:TmuxNavigateRight<CR>

nnoremap <C-j> <cmd>:TmuxNavigateDown<CR>
nnoremap <C-k> <cmd>:TmuxNavigateUp<CR>
nnoremap <C-h> <cmd>:TmuxNavigateLeft<CR>
nnoremap <C-l> <cmd>:TmuxNavigateRight<CR>

inoremap <C-j> <cmd>:TmuxNavigateDown<CR>
inoremap <C-k> <cmd>:TmuxNavigateUp<CR>
inoremap <C-h> <cmd>:TmuxNavigateLeft<CR>
inoremap <C-l> <cmd>:TmuxNavigateRight<CR>

" Repeat same mappings for terminal mode in neovim
tnoremap <C-j> <cmd>:TmuxNavigateDown<CR>
tnoremap <C-k> <cmd>:TmuxNavigateUp<CR>
tnoremap <C-h> <cmd>:TmuxNavigateLeft<CR>
tnoremap <C-l> <cmd>:TmuxNavigateRight<CR>


"""""""""""""""""""""""""""" himalaya """""""""""""""""""""""
let g:himalaya_mailbox_picker =  'telescope'
let g:himalaya_telescope_preview_enabled = 0
lua <<EOF
-- packer has issues with loading rtp: https://github.com/wbthomason/packer.nvim/issues/274
vim.o.rtp = vim.o.rtp .. ',' .. vim.fn.stdpath('data') .. '/site/pack/packer/start/himalaya/vim/'
EOF


"""""""""""""""""""""""""""" zen-mode """"""""""""""""""""""""""""""""
noremap <silent> <leader>v :ZenMode<CR>


"""""""""""""""""""""""""""" packer  """"""""""""""""""""""""""""""""
" TODO: Move this section to plugins.lua
" Make it quicker to install plugins
autocmd FileType vim,lua nnoremap <buffer> <leader>ci :source %<bar>PackerInstall<CR>
" Sometimes I just wanna load the current file
autocmd FileType vim,lua nnoremap <buffer> <leader>cc :source %<CR>


"""""""""""""""""""""""""""" vimtex """""""""""""""""""""""""""""""""
"" Vimtex settings
let g:tex_flavor='latex'
let g:vimtex_view_method='skim'
let g:vimtex_quickfix_ignore_filters = [ '\v(Under|Over)full \\(h|v)box'] " Ignore some latex 'errors'
let g:vimtex_quickfix_open_on_warning=0


""""""""""""""""""""""" lnvimrc.vim """"""""""""""""""""""""""""""""
"" Local vimrc
let g:localvimrc_debug=1
let g:localvimrc_name=['.lnvimrc']
" Whitelist everything in home directory
" https://stackoverflow.com/a/48519356
let g:localvimrc_whitelist = [ fnamemodify('~', ':p') ]
" Disable "sandbox" mode
let g:localvimrc_sandbox=0


""""""""""""""""""""""""" session.vim """""""""""""""""""""""""""""""
" Set latex filetypes as tex, not plaintex
let session_file=".Session.vim"
" https://github.com/tpope/vim-obsession/issues/17
augroup ObsessionGroup
  autocmd!
  " When opening a file, start recording the Vim session.
  " If Vim is called without arguments and there is already a session file,
  " source it and record the session.
  " Checking 'modified' avoids recording a session when reading from stdin.
  " !argc() makes sure we only source a session file if Vim was started without arguments.
  " Otherwise we would open an old session instead of opening a file when calling 'vim my_file'.
  " Calling Obsession when the session is being recorded would pause the recording,
  " that's why we check if v:this_session is empty.
  autocmd VimEnter * nested
      \ if !&modified |
      \   if !argc() && filereadable(session_file) |
      \   execute "source" session_file |
      \   elseif empty(v:this_session) |
      \     execute "Obsession" session_file |
      \   endif |
      \ endif
augroup END


""""""""""""""""""""" vim-airline """""""""""""""""""""""""""""""""""
" Status line theme is whatever base16 theme I am using
" let g:airline_theme='base16'
let g:airline_theme='base16_snazzy'
" No error messages about whitespaces please
let g:airline#extensions#whitespace#enabled = 0

" Without this, airline truncates the filename instead of the git branch when 
" space gets tight
let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 79,
      \ 'x': 60,
      \ 'y': 88,
      \ 'z': 45,
      \ 'warning': 80,
      \ 'error': 80,
      \ }

"""""""""""""""""""""""" vim-markdown """""""""""""""""""""""""""""""
" Markdown fenced languages support
" Thanks to https://thoughtbot.com/blog/profiling-vim, I now know that the following is
" what causes slow open times for markdown files.
let g:markdown_fenced_languages = ['json', 'bash']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
""" Markdown, make preview available remotely (ie, serve on 0.0.0.0, not localhost)
let g:mkdp_open_to_the_world = 1
augroup MarkdownRelated
    au!
	au FileType markdown nmap <Leader>m <Plug>MarkdownPreviewToggle<CR>
augroup END


"""""""""""""""""""" fugitive.vim """""""""""""""""""""""
nnoremap <Leader>gs :Git!<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gpull --rebase<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gg :Git 


"""""""""""""""""""""" netrw """""""""""""""""""""""
let g:netrw_localrmdir='rm -r' " Allow netrw to remove non-empty local directories
let g:netrw_keepdir=1 " Make netrw moving work 
let g:netrw_sort_by='time' " Netrw sort by time in descending order
let g:netrw_sort_direction='reverse'


"""""""""""""""""""""""""""" indent-blankline """""""""""""""""""""""""""
let g:indent_blankline_buftype_exclude = ['terminal']


"""""""""""""""""""""""""""" dap-virtual-text """""""""""""""""""""""
let g:dap_virtual_text = 'all frames'


"""""""""""""""""""""""""" Secondary init file """""""""""""""""""""""""""""
" Include a "secondary" init file that is machine-specific (ie, not racked in this repo)
let s:secondary_init_vim=expand('~/.secondary.init.vim')
if filereadable(s:secondary_init_vim)
    execute 'source' s:secondary_init_vim
endif
