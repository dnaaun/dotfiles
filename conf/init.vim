call plug#begin()
Plug 'embear/vim-localvimrc'

Plug 'christoomey/vim-tmux-navigator'

"Docker

" Vim for frontend
Plug 'pangloss/vim-javascript', {'for': ['javascript'] }
Plug 'AndrewRadev/tagalong.vim', {'for': ['html'] }
Plug 'mattn/emmet-vim', { 'for': ['html'] }
Plug 'shime/vim-livedown', { 'for': ['markdown'] }


" Markdown
Plug 'godlygeek/tabular', { 'for': ['markdown'] }
Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
Plug 'iamcco/markdown-preview.nvim', {
            \ 'for': ['markdown'],
            \ 'do': { -> mkdp#util#install() },
            \ }


" Tpope's plugins are to ViM, what ViM is to Vi
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'

" File browsing
" Plug 'francoiscabrol/ranger.vim'

" Colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'

" Coding
Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
Plug '$HOME/git/ale'
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug '5long/pytest-vim-compiler'

"
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" My own tiny touches
Plug '$HOME/git/dotfiles/conf/david.vim'

call plug#end()


" Enable nvimrc as the local initialization file
let g:localvimrc_name=['.lnvimrc']
" Whitelist everything in home directory
" https://stackoverflow.com/a/48519356
let g:localvimrc_whitelist = fnamemodify('~', ':p')

" Disable "sandbox" mode
let g:localvimrc_sandbox=0

"" Frontend customization
let g:tagalong_verbose = 1

" allow % to match HTML blocks
packadd! matchit

" Ultisnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Supertab, do context senstive selection of what to ocmplete
let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = '<C-x><C-o>'
" Preseclt the first compleition and allow enter to select it
" Show compleition menu even when only one match is there, and also show
" preview window. Look right below for why 'longest' is here.
" set completeopt=menuone,preview,longest

" Trusting this promise from SuperTab docs:

" close compleition window
" let g:SuperTabClosePreviewOnPopupClose = 1

" ALE settings
" Use ale for omnifunc
" setlocal omnifunc=ale#completion#OmniFunc
" let g:ale_completion_autoimport=1

let g:ale_open_list = 0
let g:ale_virtual_text_cursor = 1
let g:ale_virtualtext_delay = 0
let g:ale_echo_cursor = 1

" Jedi takes over a bunch of key mappings if I don't do this
let g:jedi#auto_initialization = 0




" Disable indenting lines more than necessary when typing :
" This doens't work in ftplugin/python.vim or after/python.vim.
" https://stackoverflow.com/a/37889460/13664712
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:

" Mark down blockquotes work nicer like this
autocmd FileType markdown set fo-=r
autocmd FileType markdown set fo+=oc



"Relative line numbers!
set rnu

" Automatically save views
augroup SaveViewsOnEnter
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview 
augroup END


" Bash
autocmd FileType sh setlocal makeprg=bash\ %

let g:ale_fix_on_save = 0
let g:lint_on_enter = 1
let g:ale_hover_to_preview = 1
" Show ale balloons quicker
set updatetime=100



" Don't check if AST after formatting is equivalent
" to AST before.
let g:ale_python_black_options = '--fast'

" Bandit options
" Stop warning about asserts
let g:ale_python_bandit_options = '-ll'

let g:ale_fixers = {
      \ 'python': ['black',],
      \ 'javascript': ['prettier']
      \}

let g:ale_linters = {
      \ 'python': ['mypy', 'flake8', 'bandit'],
      \ 'html': [ 'htmlhint'],
      \ 'css': ['stylelint'],
      \ 'javascript': ['eslint', 'prettier']
      \}


" Other vim preferences
set splitbelow
set splitright

" Enable backspace on everythiing
set backspace=indent,eol,start

" Line numbers
set number

" Base16 autopickup
if filereadable(expand('~/.vimrc_background'))
  let base16colorspace=256
    source ~/.vimrc_background
endif
set bg=dark


let session_file=".Session.vim"
" https://github.com/tpope/vim-obsession/issues/17
augroup ObsessionGroup
  autocmd!
  " When opening a file, start recording the Vim session with its tabs and splits.
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
      \     execute "Obsession" session_file|
      \   endif |
      \ endif
augroup END

" Status line theme is whatever base16 theme I am using
let g:airline_theme='base16'


" Resize vim splists with a mouse when inside tmux
set mouse+=a

" Draw a line at wrapwidth
set colorcolumn=+1


" Netrw
" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'

" Make netrw moving work 
let g:netrw_keepdir=1


" Start markdown preview as soon as I enter a markdown file
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0

" Markdown fenced languages support
let g:markdown_fenced_languages = ['json', 'javascript', 'html', 'python', 'bash=sh']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0


"""""" Mappings
""""""
" Change leader
let mapleader = ","

" close  preview/quickfix/locationlist windows all at once.
nnoremap <Leader>c :cclose <bar> pclose <bar> lclose<CR>

" Dispatch related shortcuts
" open and close quickfix
nnoremap <Leader>qo :copen<CR>
" make using compiler in bg
nnoremap m<CR>  :Make!<CR>

" Same pattern for loclist
nnoremap <Leader>lo :lopen<CR>
nnoremap <Leader>lc :lclose<CR>

" Save easier
noremap <Leader>s :update<CR>

augroup MarkdownRelated
	au BufEnter,BufRead,BufNewFile *.md nmap <Leader>m <Plug>MarkdownPreviewToggle
augroup END


" fzf shortcuts
" Here's the logic. 'X' means it can be any letter.
"   <Leader>fX is for :Files
"   <Leader>gX is for :Ag
"   <Leader>Xa is for for [a]nywhere 
"                 (will drop to vim prompt with :Files or :Ag prefilled)
"   <Leader>Xd is for current directory. Will execute :Files or :Ag in current
"                 [d]ir.
"   <Leader>Xf is for current directory. Will execute :Files or :Ag in dir of 
"                 of current file.
nnoremap <Leader>ff :execute 'Files' . expand('%:p:h')<CR> 
nnoremap <Leader>fc :Files<CR> 
nnoremap <Leader>fa :Files 
nnoremap <Leader>gf :execute 'Ag' . expand('%:p:h')<CR> 
nnoremap <Leader>gc :Ag<CR> 
nnoremap <Leader>ga :Ag 

" Search through buffers and history
nnoremap <Leader>h: :History:<CR> 
nnoremap <Leader>h/ :History/<CR>
nnoremap <Leader>b :Buffers<CR> 


" Neovim's terminal mode, escape with Ctrl-P which happens to
" be my Tmux "leader" key, which works great cuz I don't see
" a reason to use Neovim's :terminal inside tmux.
tnoremap <C-p> <C-\><C-n>

" ALE mappings
nnoremap <Leader>ah :ALEHover<CR>
nnoremap <Leader>af :ALEFix<CR>
