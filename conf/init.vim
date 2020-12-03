" Use non-venv python for pynvim always
"let b:ale_open_list = 0
let g:ale_virtual_text_cursor = 1
let g:ale_virtualtext_delay = 0
let g:ale_echo_cursor = 1
let g:ale_fix_on_save = 0
let g:ale_lint_on_enter = 0
let g:ale_hover_to_preview = 0 " Conflicts with echodoc, which is more useful.
let g:ale_completion_enabled = 0
let g:ale_completion_delay = 0
let g:ale_completion_autoimport = 1



let g:python3_host_prog='/usr/bin/python3'

" Make ultisnips use other triggers so mucomplete can do it's thing
let g:UltiSnipsExpandTrigger = "<c-e>"        " Do not use <tab>
let g:UltiSnipsJumpForwardTrigger = "<c-f>"   " Do not use <c-j>
let g:UltiSnipsJumpBackwardTrigger = "<c-b>"

" Vimwiki takes over .md files if I don't set this. This way, the extension
" .wiki only is associated with vimwiki, but it's set to markdown format.
let g:vimwiki_ext2syntax={'.wiki': 'markdown'}

" Mucomplete
" Prevent the wrapper mappings of mucomplete to facilitate autoimport by ALE
let g:mucomplete#no_popup_mappings = 0
let g:mucomplete#enable_auto_at_startup = 0 " automatic completion(as opposed to <tab>-triggered)
" For now, ALE is on top.

" Deoplete
let g:deoplete#enable_at_startup = 1
 " <tab>: completion.
" inoremap <expr><tab>  pumvisible() ? "\<C-n>" : "\<TAB>"


call plug#begin()
Plug 'embear/vim-localvimrc'
Plug 'christoomey/vim-tmux-navigator'

" Vim for frontend
Plug 'pangloss/vim-javascript', {'for': ['javascript'] }
Plug 'AndrewRadev/tagalong.vim', {'for': ['html'] }
Plug 'mattn/emmet-vim', { 'for': ['html'] }

" Markdown/writing
Plug 'godlygeek/tabular', { 'for': ['markdown'] }
Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
Plug 'iamcco/markdown-preview.nvim', {
            \ 'for': ['markdown'],
            \ 'do': { -> mkdp#util#install() },
            \ }
Plug 'dkarter/bullets.vim',  { 'for': ['markdown'] }

" Tpope's plugins are to ViM, what ViM is to Vi
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'

" Colors and other niceties 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/goyo.vim'

" Coding
Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
Plug 'SirVer/ultisnips'
Plug '$HOME/git/ale'
Plug 'lifepillar/vim-mucomplete'
Plug 'Shougo/echodoc.vim'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'ervandew/supertab' 

" Tex, writing
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'KeitaNakamura/tex-conceal.vim'
Plug 'vimwiki/vimwiki'
Plug 'itchyny/calendar.vim'

"
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" My own tiny touches
Plug '$HOME/git/dotfiles/conf/david.vim'
call plug#end()

let g:echodoc#type="floating"
let g:echodoc#enable_at_startup=1 
set cmdheight=2
" To use a custom highlight for the float window,
" change Pmenu to your highlight group
highlight link EchoDocFloat Pmenu

let g:vista_default_executive='ale'
let g:vista_fzf_preview = ['right:50%']

" Set zathura as viewer for latex preview pdfs
let g:livepreview_previewer = 'zathura'

" Enable nvimrc as the local initialization file
let g:localvimrc_debug=1
let g:localvimrc_name=['.lnvimrc']
" Whitelist everything in home directory
" https://stackoverflow.com/a/48519356
let g:localvimrc_whitelist = [ fnamemodify('~', ':p') ]

" Disable "sandbox" mode
let g:localvimrc_sandbox=0

"" Frontend customization
let g:tagalong_verbose = 1

" allow % to match HTML blocks
" packadd! matchit

"" Stuff I wish was in ftplugin/, but doesn't work there.
" Jedi takes over a bunch of key mappings if I don't do this
let g:jedi#auto_initialization = 0
" Set latex filetypes as tex, not plaintex
let g:tex_flavor='latex'

let g:goyo_height=100
" Make Goyo make tmux panes dissapear
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Disable indenting lines more than necessary when typing :
" This doens't work in ftplugin/python.vim or after/python.vim.
" https://stackoverflow.com/a/37889460/13664712
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:

" Mark down blockquotes work nicer like this
autocmd FileType markdown set formatoptions-=ro
autocmd FileType markdown set formatoptions+=c

" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 2


" menuone so that autoimport cna work with one completion
" preview to get more info
" noinsert because ALE is too eager with it's completiions sometimes
" noinsert cuz ALE docs recommend, don't know why
set completeopt=menu,menuone,preview,noinsert
set completeopt-=longest " This doens't make sense.

"Relative line numbers!
set rnu

" Automatically save views
augroup SaveViewsOnEnter
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview 
augroup END


" Bash
autocmd FileType sh setlocal makeprg=bash\ %

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
" colorscheme seoul256


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

" ALE Settings
" Show status using vim airline
let g:airline#extensions#ale#enabled = 1

" Only lint when I ask
let g:ale_linters_explicit=1

" Nice to know which linter is dissatisfied
let g:ale_echo_msg_format = '%linter%:%severity%:%code:%%s'



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

" Goyo. Distraction free writing.
" No justification for key choice except that it's the shortest that's not yet taken.
nnoremap <leader>t :Goyo<CR>


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

" Read vimrc again.
noremap <Leader>ri :source $MYVIMRC<CR>
" Reload file, usually triggers filetype plugin reload and local vimrc
" reload.
noremap <Leader>rr :edit<CR>

augroup MarkdownRelated
    au!
	au FileType markdown nmap <Leader>m <Plug>MarkdownPreviewToggle<CR>
    
    "  https://github.com/reedes/vim-lexical/blob/master/autoload/lexical.vim
    "  Go into insert mode
    au FileType markdown nmap  <Leader>s ]svaWovEa<C-X><C-S>
augroup END


" fzf shortcuts
" second f for search in directory of curetn *F*ile
nnoremap <Leader>ff :execute 'Files' . expand('%:p:h')<CR> 
" c for current dir
nnoremap <Leader>fc :Files<CR> 
" a for Ag
nnoremap <Leader>fa :Ag<CR> 
" Search through buffers and history
nnoremap <Leader>f: :History:<CR> 
nnoremap <Leader>f/ :History/<CR>
nnoremap <Leader>fb :Buffers<CR> 


" Neovim's terminal mode, escape with Ctrl-P which happens to
" be my Tmux "leader" key, which works great cuz I don't see
" a reason to use Neovim's :terminal inside tmux.
tnoremap <C-p> <C-\><C-n>

" ALE mappings
nnoremap <Leader>ah :ALEHover<CR>
nnoremap <Leader>af :ALEFix<CR>
nnoremap <Leader>ai :ALEInfo<CR>
nnoremap <Leader>au :ALEFindReferences<CR>
nnoremap <Leader>al :ALELint<CR>
nnoremap <Leader>aa :ALECodeAction<CR>
nnoremap <Leader>ad :ALEGoToDefinition<CR>
nnoremap <Leader>at :ALEGoToTypeDefinition<CR>
nnoremap <Leader>ar :ALERename<CR>
" t for toggle
nnoremap <Leader>at :ALEDisable <bar> ALEStopAllLSPs <bar> ALEEnable <bar> ALELint<CR>

" Jedi mappings
nnoremap <Leader>ju :call jedi#usages()<CR>
nnoremap <Leader>jk :call jedi#show_documentation()<CR>
nnoremap <Leader>jd :call jedi#goto_assignments()<CR>
nnoremap <Leader>jt :call jedi#goto_stubs()<CR>
nnoremap <Leader>jr :call jedi#rename()<CR>
let g:jedi#auto_initialization=0  " Don't take over
let g:jedi#completions_enabled=0 " Pyright+ALE=autoimport
let g:jedi#show_call_signatures=2  " Show ginatures in window
let g:jedi#show_call_signatures_delay=0 " Show ginatures in window


" t for toggle
nnoremap <Leader>at :ALEDisable <bar> ALEStopAllLSPs <bar> ALEEnable <bar> ALELint<CR>

" Fugutive mappings
nnoremap <Leader>gs :Git!<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gp :Gpull --rebase<CR>
nnoremap <Leader>gg :Git 


" Reload vimrc and filetype plugins



" Allow a 'computer dependent' initialization
let s:secondary_init_vim=expand('~/.secondary.init.vim')
if filereadable(s:secondary_init_vim)
    execute 'source' s:secondary_init_vim
endif

