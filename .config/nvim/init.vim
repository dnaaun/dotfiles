call plug#begin()
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'easymotion/vim-easymotion'

" Avoid loading most plugins if we're on a temporary  file (which is the case when 
" bash launches my $EDITOR to edit my commands, which I often do), for speed purposes. 
let s:temp_file_ptrn = '\v^/(tmp|scratch)/.*'
let s:NOT_IN_TEMP_FILE =  !(expand('%') =~ s:temp_file_ptrn)

if (s:NOT_IN_TEMP_FILE)
    Plug 'embear/vim-localvimrc'

   " Python
    Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
    Plug 'bfredl/nvim-ipy', { 'for': ['python'] }
    Plug 'jeetsukumaran/vim-pythonsense', { 'for': ['python'] }
    Plug 'tartansandal/vim-compiler-pytest', { 'for': ['python'] }

    " General coding
    Plug '$HOME/git/ale'
    Plug 'vim-test/vim-test'
    Plug 'liuchengxu/vista.vim'
    Plug 'SirVer/ultisnips'
    Plug 'wellle/targets.vim' " text objects on steriods

    " Frontend
    Plug 'pangloss/vim-javascript', {'for': ['javascript'] } " Trusted the internet's recommendations. Not sure if I actually need it
    Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescriptreact'] } " Trusted the internet's recommendations. Not sure if I actually need it
    Plug 'maxmellon/vim-jsx-pretty' , { 'for': ['typescript', 'typescriptreact'] } " Trusted the internet's recommendations. Not sure if I actually need it.
    Plug 'Valloric/MatchTagAlways', { 'for': ['typescript', 'typescriptreact'] } " shows the matching tag of the tag under cursor
    Plug 'skammer/vim-css-color', { 'for': ['css'] } " highlights color codes with the color

    " Markdown/writing
    Plug 'godlygeek/tabular', { 'for': ['markdown'] }
    Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
    Plug 'iamcco/markdown-preview.nvim', {
                \ 'for': ['markdown'],
                \ 'do': { -> mkdp#util#install() },
                \ }
    Plug 'dkarter/bullets.vim',  { 'for': ['markdown'] }


    " Tpope makes great plugins.
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-scriptease'

    " Editing text
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'tpope/vim-obsession'
    Plug 'tpope/vim-repeat'
    Plug 'easymotion/vim-easymotion'
    

    " Colors and other niceties
    Plug '$HOME/git/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'

    " Tex, writing
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'KeitaNakamura/tex-conceal.vim', { 'for': 'tex' }

    " Fzf and file manager
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'Shougo/defx.nvim',  { 'do': ':UpdateRemotePlugins' }

    " My own touches
    Plug '$HOME/git/dotfiles/conf/david.vim'
else
    echomsg 'Tmp file: not loading some plugins'
endif
call plug#end()

"" Match tag always
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \ 'typescriptreact' : 1,
    \}

"" Netrw sort by time in descending order
let g:netrw_sort_by='time'
let g:netrw_sort_direction='reverse'

"" Easymotion
let g:EasyMotion_do_mapping=0 " no default mappings
map sw <Plug>(easymotion-wl)
map sb <Plug>(easymotion-bl)
map sW <Plug>(easymotion-Wl)
map sB <Plug>(easymotion-Bl)
map se <Plug>(easymotion-el)
map sE <Plug>(easymotion-El)
map s<Space>  <Plug>(easymotion-fl) 

"" Surround.vim
" This is because ys conflicts with easymotion
" let g:surround_no_mappings=1


"" Vista.vim
let g:vista_default_executive='ale'
let g:vista_fzf_preview=[] " enable fzf preview, I think
let g:vista_keep_fzf_colors=1


"" vim-test
let test#strategy = "dispatch"

"" dispatch.vim
let g:dispatch_tmux_height = 30 " Foundt this by reading dispatch.vim source code


"" Vimtex settings
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_ignore_filters = [ '\v(Under|Over)full \\(h|v)box'] " Ignore some latex 'errors'
let g:vimtex_quickfix_open_on_warning=0


""" Markdown, make preview available remotely (ie, serve on 0.0.0.0, not localhost)
let g:mkdp_open_to_the_world = 1

"" ALE Settings
let g:airline#extensions#ale#enabled = 1 " Show status using vim airline
let g:ale_fix_on_save = 0
" Diagnostics
let g:ale_linters_explicit=1 " Only lint with linters I explicitly I ask for
let g:ale_echo_msg_format = '%linter%:%severity%:%code:%%s' " Nice to know which linter is dissatisfied
let g:ale_virtualtext_cursor = 1 " Show errors in virtualtext
let g:ale_virtualtext_delay = 0
let g:ale_echo_cursor = 0 " Use echo for ALE errors
let g:ale_lint_on_enter = 0
set updatetime=200  " Trigger ALEHover quicker
let g:ale_cursor_detail = 0 " Show ale diagnostics regarding current line automatically with cursor changing lines
let g:ale_hover_to_preview = 1
" Using an off-master branch with this feature
let g:ale_floating_preview = 1
let g:ale_hover_to_floating_preview=0
" Completion
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 0
let g:ale_completion_autoimport = 1
" Make ALE more readable
highlight link ALEVirtualTextError Exception
highlight link ALEError DiffDelete

augroup HoverAfterComplete                                                        
    autocmd!                                                                    
    " display argument list of the selected completion candidate using ALEHover
    autocmd User ALECompletePost ALEHover                                       
augroup END

" Use whatever python3 virtualenv is currently activated.
" Means I have to install pynvim in every venv, but makes life easier.
let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')

"" Ultisnips
let g:UltiSnipsExpandTrigger = "<A-e>"
let g:UltiSnipsJumpForwardTrigger = "<A-f>"
let g:UltiSnipsJumpBackwardTrigger = "<A-b>"

"" nvim-ipy
let g:nvim_ipy_perform_mappings = 0
let g:ipy_celldef = '\v^\s*##[^#]*$' " Ipython cell boundary line regex.

set nohlsearch " Don't higlight all matches
set incsearch " Incremental search highlight
" Add parenthesis to vaid filename chars for completion
set isfname+=(
set isfname+=)

set completeopt=menu,menuone,noinsert,noselect,preview


"" Local vimrc
let g:localvimrc_debug=1
let g:localvimrc_name=['.lnvimrc']
" Whitelist everything in home directory
" https://stackoverflow.com/a/48519356
let g:localvimrc_whitelist = [ fnamemodify('~', ':p') ]
" Disable "sandbox" mode
let g:localvimrc_sandbox=0

"" Stuff I wish was in ftplugin/, but doesn't work there.
" Jedi takes over a bunch of key mappings if I don't do this
let g:jedi#auto_initialization = 0
" Set latex filetypes as tex, not plaintex

" Disable indenting lines more than necessary when typing :
" This doens't work in ftplugin/python.vim or after/python.vim.
" https://stackoverflow.com/a/37889460/13664712
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:

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

" Enable backspace on everything
set backspace=indent,eol,start


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
      \ if !&modified && s:NOT_IN_TEMP_FILE |
      \   if !argc() && filereadable(session_file) |
      \   execute "source" session_file |
      \   elseif empty(v:this_session) |
      \     execute "Obsession" session_file |
      \   endif |
      \ endif
augroup END

"" Colors
" https://browntreelabs.com/base-16-shell-and-why-its-so-awsome/
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

"" Airline
" Status line theme is whatever base16 theme I am using
let g:airline_theme='base16'
" No error messages about whitespaces please
let g:airline#extensions#whitespace#enabled = 0

" Resize vim splists with a mouse when inside tmux
set mouse+=a

" Draw a line at wrapwidth
set colorcolumn=+1


"" Netrw
" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'
" Make netrw moving work 
let g:netrw_keepdir=1


"" Markdown related
set conceallevel=2
let g:vim_markdown_conceal = 1

" Markdown fenced languages support
let g:markdown_fenced_languages = ['json', 'javascript', 'html', 'python', 'bash=sh']
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0


"""""" Mappings
""""""
" Change leader
let mapleader = ","
let maplocalleader = ","

" WHen in visual/select/operator mode, I want searching with / to be an inclusive
" motion. This is acheived by doing /pattern/e, but I don't wanna have to type
" that /e everytime so:
vnoremap / //e<Left><Left>
onoremap / //e<Left><Left>

" ]s means go to next spelling error.
nnoremap  <Leader>s ]s1z=<C-X><C-S>

" https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
" Insert mode, correct last error.
inoremap <C-s> <c-g>u<Esc>[s1z=`]a<c-g>u

" Inspired by unimpaired, jump to the last location on jumplist
" that is NOT in the current file
:ech
" <tab> in visual mode starts goes into insert mode with UltiSnips ready to
" integrate the visual selection into an expanded snippet.
xmap  <tab> :call UltiSnips#SaveLastVisualSelection()<CR>gvc

"" vim-ipy
" leader-e is mapped to running text objects, but since I never
" wanna run till end of word(which is 'e'), but much more commonly to end of line...
"" Run arbitrary text objects. The first one uses i unlike most of
" of my nvim-ipy maps because I wanna run arbitrary text objects,
" which conflict with the two letter mappings.
nmap <silent> <leader>i <Plug>(IPy-RunOp)
vmap <silent> <leader>i <Plug>(IPy-Run)
nmap <silent> <leader>ee <Plug>(IPy-Run) 
nmap <silent> <leader>ea <Plug>(IPy-RunAll)
nmap <silent> <leader>ec <Plug>(IPy-RunCell)
nmap <silent> <leader>eq <Plug>(IPy-Terminate)
nmap <silent> <leader>ei :IPython<CR>
nmap <silent> <leader>ek <Plug>(IPy-WordObjInfo)
imap <silent> <C-f> <Plug>(IPy-Complete)



" Dispatch related shortcuts
" open and close quickfix
nnoremap <Leader>qo :copen<CR>
nnoremap <Leader>qc :cclose<CR>

" make using compiler in bg
nnoremap m<CR>  :Make!<CR>

" Same pattern for loclist
nnoremap <Leader>lo :lopen<CR>
nnoremap <Leader>lc :lclose<CR>

" Reload config
nnoremap <Leader>rr :source $MYVIMRC <bar> let &filetype=&filetype <bar> LocalVimRC<CR>

augroup MarkdownRelated
    au!
	au FileType markdown nmap <Leader>m <Plug>MarkdownPreviewToggle<CR>
augroup END

" Expand * to do cross file search when prefixed by <leader>f
nnoremap <Leader>f* :execute 'Rg ' . expand('<cword>')<CR> 
vnoremap <Leader>f y:execute 'Rg ' . @0<CR> 
" second f for search in directory of current *F*ile
nnoremap <Leader>ff :execute 'Files' . expand('%:p:h')<CR> 
nnoremap <Leader>fv :Vista finder fzf:ale<CR> 
" c for current dir
nnoremap <Leader>fc :Files<CR> 
nnoremap <Leader>fr :Rg<CR>
" Search through buffers and history
nnoremap <Leader>fh :History<CR> 
nnoremap <Leader>f: :History:<CR> 
nnoremap <Leader>f/ :History/<CR>
nnoremap <Leader>fb :Buffers<CR> 
" Go to LSP symbols
nnoremap <Leader>fs :Vista finder<CR>

" Run tests
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>


" Neovim's terminal mode, escape with Ctrl-P which happens to
" be my Tmux "leader" key, which works great cuz I don't see
" a reason to use Neovim's :terminal inside tmux.
tnoremap <C-p> <C-\><C-n>

" ALE mappings
nnoremap <Leader>ah :ALEHover<CR>
" ad is taken by ALEDocumentation
nnoremap <Leader>aj :ALEDetail<CR>
nnoremap <Leader>af :ALEFix<CR>
nnoremap <Leader>ai :ALEInfo<CR>
nnoremap <Leader>au :ALEFindReferences<CR>
nnoremap <Leader>al :ALELint<CR>
nnoremap <Leader>aa :ALECodeAction<CR>
nnoremap <Leader>ad :ALEGoToDefinition<CR>
nnoremap <Leader>at :ALEGoToTypeDefinition<CR>
nnoremap <Leader>ar :ALERename<CR>
" restart ('quit' is the mnemonic. Go figure.)
nnoremap <leader>aq :ALEDisable <bar> ALEStopAllLSPs <bar> ALEEnable <bar> ALELint<cr>
" inoremap <expr> <tab> pumvisible() ? "\<C-n>" : "<C-x><C-o>"


" https://vi.stackexchange.com/questions/11476/
fun! GetCharAtOffset(offset)
 let l:offset = col('.') + a:offset - 1
 if l:offset < 0
     return ""
 endif
 let l:res = strcharpart(strpart(getline('.'), l:offset), 0, 1)
 echom "CharAtOffset ='" . l:res . "'"
  return l:res
endfun


function! WhenTabKeyPressed()
    if pumvisible()
        return "\<C-n>"
    else
        " \k uses &iskeyword
        if GetCharAtOffset(-1) =~ '\k'
            return "\<C-x>\<C-o>"
        else
            " TODO: This is a workaround. This should be result of pressing <tab> according to all the vars like expandtab, ...etc.
            return "  " 
        endif
    endif
endfunction 

inoremap <expr> <tab> WhenTabKeyPressed()
inoremap <expr> <s-tab> pumvisible() ? "\<C-p>" : "\<s-tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Jedi mappings
nnoremap <Leader>ju :call jedi#usages()<CR>
nnoremap <Leader>jk :call jedi#show_documentation()<CR>
nnoremap <Leader>jd :call jedi#goto_definitions()<CR>
nnoremap <Leader>ja :call jedi#goto_assignments()<CR>
nnoremap <Leader>jt :call jedi#goto_stubs()<CR>
nnoremap <Leader>jr :call jedi#rename()<CR>
let g:jedi#auto_initialization=0  " Don't take over mappings, autocomplete, etc.
let g:jedi#completions_enabled=0 " Mycomplete
let g:jedi#show_call_signatures=2  " Show ginatures in window
let g:jedi#show_call_signatures_delay=0 " Show ginatures in window

"" Fugutive mappings
nnoremap <Leader>gs :Git!<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gpull --rebase<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gg :Git 

"" Limelight
let g:limelight_paragraph_span=5
let g:limelight_bop = '^'
let g:limelight_eop = '$'
" When using fzf terminal splits, toggle Limelight.
" This exists() trick below was taken by reading limelight src at
" autoload/limelight.vim
let s:ll_was_on=0
function! s:fzf_enter()
   let s:ll_was_on=exists("#limelight")
   Limelight!
   " Limelight listens to this autocmds to start doing things.
   " This is also from the docs.
   doautocmd CursorMoved
endfunction

function! s:fzf_leave()
    echom 'filetype=' . json_encode(&filetype)
    echom 'ss:ll_was_on=' json_encode(s:ll_was_on)
    if &filetype == 'fzf' && s:ll_was_on
        Limelight!!
    endif
endfunction


augroup fzf_enter
    au!
    autocmd FileType fzf call <SID>fzf_enter()
    autocmd TermClose * call <SID>fzf_leave()
augroup END

"" Goyo 
let g:goyo_height=100
" Variable to keep track of Goyo state to facilitate toggling.
" Just :Goyo would toggle, except that I want to read textwidth
" dynamically (and thus do :exec Goyo &tw), which doesn't toggle.
if ! exists('g:goyo_on')
    let g:goyo_on = 0
endif
function! GoyoToggle()
    if ! g:goyo_on
        if &textwidth > 0 " If we're doing hard wrapping
            " + 3 for good measure (aka error indicators from ALE)
            execute 'Goyo ' &textwidth + 3 
        else
            Goyo
        endif

        let g:goyo_on = 1
    else
        Goyo!
        let g:goyo_on = 0
    endif
endfunction
nmap <silent> <leader>v :call GoyoToggle()<CR>

function! s:goyo_enter()
" Make Goyo make tmux panes dissapear
  " if executable('tmux') && strlen($TMUX)
    " silent !tmux set status off
    " silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  " endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
endfunction

function! s:goyo_leave()
  " if executable('tmux') && strlen($TMUX)
    " silent !tmux set status on
    " silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  " endif
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"" vim-tmux-navigator
" Map the keys used in normal mode for tmux/vim navigation in insert mode 
" as well
inoremap <C-j> <C-\><C-o>:TmuxNavigateDown<CR>
inoremap <C-k> <C-\><C-o>:TmuxNavigateUp<CR>
inoremap <C-h> <C-\><C-o>:TmuxNavigateLeft<CR>
inoremap <C-l> <C-\><C-o>:TmuxNavigateRight<CR>

""" Allow a 'computer dependent' initialization
let s:secondary_init_vim=expand('~/.secondary.init.vim')
if filereadable(s:secondary_init_vim)
    execute 'source' s:secondary_init_vim
endif


