call plug#begin()
Plug 'christoomey/vim-tmux-navigator'

"Docker
Plug 'ekalinin/Dockerfile.vim'
Plug 'chr4/nginx.vim'

" Vim for frontend
Plug 'pangloss/vim-javascript'
Plug 'AndrewRadev/tagalong.vim'
Plug 'mattn/emmet-vim'
Plug 'shime/vim-livedown'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': ['html', 'javascript', 'css']}


" Markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}


" Tpope's plugins are to ViM, what ViM is to Vi
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'

" File browsing
" Plug 'francoiscabrol/ranger.vim'

" Colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'

" Coding
Plug 'davidhalter/jedi-vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'dense-analysis/ale'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug '5long/pytest-vim-compiler'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
Plug 'deoplete-plugins/deoplete-jedi', { 'for': 'python' }
"
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" My own tiny touches
Plug '$HOME/dotfiles/conf/david.vim'

call plug#end()

"" Frontend customization
let g:tagalong_verbose = 1

" allow % to match HTML blocks
packadd! matchit

" Jedi takes over a bunch of key mappings if I don't do this
let g:jedi#auto_initialization = 0
" Stop jedi from opening a split with documentation after autocomplete
set completeopt-=preview

" Show call signatures
" let g:jedi#show_call_signatures = "1"
" let g:jedi#show_call_signatures_delay = 0
" call jedi#configure_call_signatures()


" Use deoplete.  
let g:jedi#completions_enabled = 0
let g:deoplete#enable_at_startup = 0

" Disable indenting lines more than necessary when typing :
" This doens't work in ftplugin/python.vim or after/python.vim.
" https://stackoverflow.com/a/37889460/13664712
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:

" Mark down blockquotes work nicer like this
autocmd FileType markdown set fo-=r
autocmd FileType markdown set fo+=oc

" Start echo doc at startup
let g:echodoc#type = 'floating'
let g:echodoc#enable_at_startup = 1 

" Remnant from YCM, not sure what to do with it now.
let g:SuperTabDefaultCompletionType = '<C-l>'

" " better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

"Relative line numbers!
set rnu

" Automatically save views
augroup SaveViewsOnEnter
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview 
augroup END


" Bash
autocmd FileType sh setlocal makeprg=bash\ %

let g:ale_fix_on_save = 1
let g:lint_on_enter = 1


" Don't check if AST after formatting is equivalent
" to AST before.
"let g:ale_python_black_options = '--fast'

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
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
    source ~/.vimrc_background
endif
set bg=dark


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
      \   if !argc() && filereadable('Session.vim') |
      \   source Session.vim |
      \   echo "Existing session sourced, recording session" |
      \   elseif empty(v:this_session) |
      \     Obsession |
      \     echo "Started new session" |
      \   endif |
      \ endif
augroup END

" Status line theme
let g:airline_theme='base16_monokai'


" Resize vim splists with a mouse when inside tmux
set mouse+=a

" Draw a line at wrapwidth
set colorcolumn=+1

" Dispatch related shortcuts
nnoremap <Leader>q :Copen<CR>
nnoremap m<CR>  :Make!<CR>

" Netrw
" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'


" Start markdown preview as soon as I enter a markdown file
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0

" Markdown fenced languages support
let g:markdown_fenced_languages = ['json', 'javascript', 'html', 'python', 'bash=sh']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

" Make netrw moving work 
let g:netrw_keepdir=0

"""""" Mappings
""""""
" Change leader
let mapleader = ","

augroup MarkdownRelated
	au BufEnter,BufRead,BufNewFile *.md nmap <Leader>m <Plug>MarkdownPreviewToggle
augroup END


" Toggle quickfix
nnoremap <Leader>q :call QuickfixToggle()<CR>


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



" TODO: Move this to a ftplugin file
nnoremap <Leader>tt :TableFormat<CR>

" Resize splits more quickly
nnoremap <silent> <Leader>a :exe "resize +2" <CR>
nnoremap <silent> <Leader>aa :exe "resize -2" <CR>

" Open netranger in directory of current file when pressing - 0
nnoremap - :e %:p:h<CR>

" Neovim's terminal mode, escape with Ctrl-P which happens to
" be my Tmux "leader" key, which works great cuz I don't see
" a reason to use Neovim's :terminal inside tmux.
tnoremap <C-p> <C-\><C-n>
