
call plug#begin()
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'easymotion/vim-easymotion'

" Avoid loading most plugins if we're on a temporary  file (which is the case when 
" bash launches my $EDITOR to edit my commands, which I often do), for speed. 
let s:temp_file_ptrn = '\v^/(tmp|scratch)/.*'
let s:NOT_IN_TEMP_FILE =  !(expand('%') =~ s:temp_file_ptrn)

if (s:NOT_IN_TEMP_FILE)
    Plug 'embear/vim-localvimrc'
    Plug 'sedm0784/vim-resize-mode'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'mhartington/oceanic-next'

    " Fzf
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

   " Python
    " Plug 'jeetsukumaran/vim-pythonsense', { 'for': ['python'] }
    " Plug 'davidhalter/jedi-vim', { 'for': ['python'] }

    " Android
    Plug 'udalov/kotlin-vim', { 'for': ['kotlin'] }

    " General coding
    Plug '$HOME/git/ale'
    Plug 'vim-test/vim-test', { 'for': ['python'] }
    Plug 'tpope/vim-dispatch', { 'for': ['python'] } " Here only cuz vim-test
    Plug 'urbainvaes/vim-ripple', {'for': ['python'] } " Send code to REPLs easily
    packadd! matchit

    "" Frontend
    Plug 'pangloss/vim-javascript', {'for': ['javascript'] } " Trusted the internet's recommendations. Not sure if I actually need it
    Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescriptreact'] } " Trusted the internet's recommendations. Not sure if I actually need it
    Plug 'maxmellon/vim-jsx-pretty' , { 'for': ['typescript', 'typescriptreact'] } " Trusted the internet's recommendations. Not sure if I actually need it.
    Plug 'Valloric/MatchTagAlways', { 'for': ['typescript', 'typescriptreact'] } " shows the matching tag of the tag under cursor
    " Plug 'skammer/vim-css-color', { 'for': ['css'] } " highlights color codes with the color

    
    "" File management
    Plug 'tpope/vim-vinegar'  " netrw

    "" Git
    Plug 'tpope/vim-fugitive' " the awesomest Git plugin ever

    "" Session management
    Plug 'tpope/vim-obsession'

    "" Writing
    " Markdown
    Plug 'tpope/vim-unimpaired'
    Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
    Plug 'iamcco/markdown-preview.nvim', {
                \ 'for': ['markdown'],
                \ 'do': { -> mkdp#util#install() },
                \ }
    Plug 'dkarter/bullets.vim',  { 'for': ['markdown'] }
    " Tex
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'KeitaNakamura/tex-conceal.vim', { 'for': 'tex' }
    Plug 'SirVer/ultisnips', { 'for': ['tex'], 'commit': '96026a4df27899b9e4029dd3b2977ad2ed819caf' } 
    
    "" Colors and other niceties
    Plug '$HOME/git/vim-airline'
    " Plug 'vim-airline/vim-airline-themes'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim' " Performance cost is too high
   
else
    echomsg 'Tmp file: not loading some plugins'
endif
call plug#end()

"" vim-ripple
" The python one is strongly informed by https://github.com/urbainvaes/vim-ripple/issues/20
let g:ripple_repls = {
            \ 'python': ['ptpython --vi', "\<c-u>\<esc>[200~", "\<esc>[201~\<cr>\<cr>", 1] 
            \ }

let g:ripple_enable_mappings=0
" Use whatever python3 virtualenv is currently activated.
" Means I have to install pynvim in every venv, but makes life easier.
let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')

"" Vim-repl
"" https://github.com/sillybun/vim-repl#setting
" Check if we're in a venv. g:python3_host_prog should be set
" to the executable from the venv already from the line above.
" let s:venv_activate_path = substitute(g:python3_host_prog, 'python$', 'activate')
" if filereadable()
    " let g:repl_python_pre_launch_command = 'source "
" Choose the repl program by filetype
let g:repl_program = { 
            \ 'python' : ['ptpython']
            \ }

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

"" vim-test
let test#strategy = "dispatch"

"" dispatch.vim
let g:dispatch_tmux_height = 10 " Foundt this by reading dispatch.vim source code

"" Vimtex settings
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_ignore_filters = [ '\v(Under|Over)full \\(h|v)box'] " Ignore some latex 'errors'
let g:vimtex_quickfix_open_on_warning=0


"" ALE Settings
let g:airline#extensions#ale#enabled = 0 " Show status using vim airline
let g:ale_fix_on_save = 0
" Diagnostics
let g:ale_linters_explicit=1 " Only lint with linters I explicitly I ask for
let g:ale_echo_msg_format = '%linter%:%severity%:%code:%%s' " Nice to know which linter is dissatisfied
let g:ale_virtualtext_delay = 0
let g:ale_lint_on_enter = 0

set updatetime=200  " Trigger ALEHover quicker
let g:ale_cursor_detail = 0 " Show ale diagnostics regarding current line automatically with cursor changing lines
let g:ale_floating_preview = 1

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


"" Ultisnips
let g:UltiSnipsExpandTrigger = "<A-e>"
let g:UltiSnipsJumpForwardTrigger = "<A-f>"
let g:UltiSnipsJumpBackwardTrigger = "<A-b>"


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
" if filereadable(expand("~/.vimrc_background"))
  " let base16colorspace=256
  " source ~/.vimrc_background
" endif

"" Airline
" Status line theme is whatever base16 theme I am using
" let g:airline_theme='base16'
let g:airline_theme='oceanicnext'
" No error messages about whitespaces please
let g:airline#extensions#whitespace#enabled = 0

"" Netrw
" Allow netrw to remove non-empty local directories
let g:netrw_localrmdir='rm -r'
" Make netrw moving work 
let g:netrw_keepdir=1


"" Markdown related
set conceallevel=2
let g:vim_markdown_conceal = 1
" Markdown fenced languages support
" Thanks to https://thoughtbot.com/blog/profiling-vim, I now know that the following is
" what causes slow open times for markdown files.
let g:markdown_fenced_languages = []
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
""" Markdown, make preview available remotely (ie, serve on 0.0.0.0, not localhost)
let g:mkdp_open_to_the_world = 1

"" Tree-sitter https://github.com/nvim-treesitter/nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
      enable = true
      }, 
  indent = {
    enable = true
  }
}
EOF


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


" Other vim preferences
set splitbelow
set splitright
set nohlsearch " Don't higlight all matches
set incsearch " Incremental search highlight
" Add parenthesis to vaid filename chars for completion
set isfname+=(
set isfname+=)
set completeopt=menu,menuone,noinsert,noselect,preview
" Enable backspace on everything
set backspace=indent,eol,start 
set mouse+=a " Resize vim splists with a mouse when inside tmux
set colorcolumn=+1 " Draw a line at wrapwidth
let &grepprg='rg -nH' " Use ripgrep as a grep program

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

" <tab> in visual mode starts goes into insert mode with UltiSnips ready to
" integrate the visual selection into an expanded snippet.
xmap  <tab> :call UltiSnips#SaveLastVisualSelection()<CR>gvc

" Vim-ripple
" Open repl
nmap <leader>ro <Plug>(ripple_open_repl)
" Send  text contained in next motion to repl
nmap <leader>r <Plug>(ripple_send_motion)
" In select mode, send selection
xmap <leader>r <Plug>(ripple_send_selection)
" Send line. Two r's to make it simple.
nmap <leader>rr <Plug>(ripple_send_line)


" Dispatch related shortcuts
" open and close quickfix
nnoremap <Leader>qo :copen<CR>
nnoremap <Leader>qc :cclose<CR>
 
" make using compiler in bg
nnoremap m<CR>  :Make!<CR>

" Same pattern for loclist
nnoremap <Leader>lo :lopen<CR>
nnoremap <Leader>lc :lclose<CR>

" cr stands for 'config reload'
nnoremap <Leader>cr :source $MYVIMRC <bar> let &filetype=&filetype <bar> LocalVimRC<CR>


augroup MarkdownRelated
    au!
	au FileType markdown nmap <Leader>m <Plug>MarkdownPreviewToggle<CR>
augroup END

" Expand * to do cross file search when prefixed by <leader>f
nnoremap <Leader>f* :execute 'Rg ' . expand('<cword>')<CR> 
vnoremap <Leader>f y:execute 'Rg ' . @0<CR> 
" second f for search in directory of current *F*ile
nnoremap <Leader>ff :execute 'Files' . expand('%:p:h')<CR> 
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
nnoremap <silent> <Leader>ah :ALEHover<CR>
" ad is taken by ALEDocumentation
nnoremap <silent> <Leader>aj :ALEDetail<CR>
nnoremap <silent> <Leader>af :ALEFix<CR>
nnoremap <silent> <Leader>ai :ALEInfo<CR>
nnoremap <silent> <Leader>au :ALEFindReferences<CR>
nnoremap <silent> <Leader>al :ALELint<CR>
nnoremap <silent> <Leader>aa :ALECodeAction<CR>
nnoremap <silent> <Leader>ad :ALEGoToDefinition<CR>
nnoremap <silent> <Leader>at :ALEGoToTypeDefinition<CR>
nnoremap <silent> <Leader>ar :ALERename<CR>
" restart ('quit' is the mnemonic. Go figure.)
nnoremap <silent> <leader>aq :ALEDisable <bar> ALEStopAllLSPs <bar> ALEEnable <bar> ALELint<cr>

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
            " TODO: This should be result of pressing <tab> according to all the vars like expandtab, ...etc, that is, not necessarily a tab character.
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
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gpull --rebase<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gg :Git 

"" Limelight and Goyo
let g:limelight_paragraph_span=5
let g:limelight_bop = '^'
let g:limelight_eop = '$'
" When using fzf terminal splits, toggle Limelight.
" This exists() trick below was taken by reading limelight src at
" autoload/limelight.vim
let s:ll_was_on=0
function! s:fzf_enter()
   let s:ll_was_on=exists("#limelight")
   " Limelight!
   " Limelight listens to this autocmds to start doing things.
   " This is also from the docs.
   doautocmd CursorMoved
endfunction
function! s:fzf_leave()
    if &filetype == 'fzf' && s:ll_was_on
        " Limelight!!
    endif
endfunction
augroup fzf_enter
    au!
    autocmd FileType fzf call <SID>fzf_enter()
    autocmd TermClose * call <SID>fzf_leave()
augroup END
" Goyo 
let g:goyo_height="100%"
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
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
endfunction
function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
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
" Repeat same mappings for terminal mode in neovim
tnoremap <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
tnoremap <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
tnoremap <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
tnoremap <C-l> <C-\><C-n>:TmuxNavigateRight<CR>

" for vim 8
if (has("termguicolors"))
    set termguicolors
endif
colorscheme OceanicNext

""" Allow a 'computer dependent' initialization
let s:secondary_init_vim=expand('~/.secondary.init.vim')
if filereadable(s:secondary_init_vim)
    execute 'source' s:secondary_init_vim
endif

" function! IsAhead(first, second)
"     if type(a:first) == v:t_dict
"         let l:first = [ a:first["lnum"], a:first["col"] ]
"     else
"         let l:first = a:first
"     endif
"     if type(a:second) == v:t_dict
"         let l:second = [ a:second["lnum"], a:second["col"] ]
"     else
"         let l:second = a:second
"     endif
"     if ( (l:first[0] > l:second[0]) || l:first[0] == l:second[0] && l:first[1] > l:second[1] )
"         return 1
"     elseif ( l:first[0] == l:second[0] && l:first[1] == l:second[1] )
"         return 0
"     else
"         return -1
"     endif
" endfunction
" 
" 
" " Vim-unimpaired maps ]l and [l to :lprev and :lnext, but 
" " :lprev and :lnext are relative to an internal marker that is
" " initiated to 1 every time the loclist is populated. 
" " I want ]l and [l to be relative to the current line, such that
" " ]l jumps to the closest location list item after/below cursor, 
" " and analogously for [l.
" function! LoclistRelative(ahead)
"     let [l:_, l:curlnum, l:curcol; l:_] = getcurpos()
"     let l:loclist = getloclist(0, ['lnum', 'col'])
"     if empty(l:loclist)
"         return
"     endif
" 
"     let l:curloc = [l:curlnum, l:curcol]
" 
"     " Binary search for loc
"     let [l:low, l:high] = [0, len(l:loclist)]
" 
"     while 1
"         " Below condition means we've found the closest thing
"         if l:low == l:high - 1
"             if a:ahead
"                 echo l:loclist[l:high]
"             else
"                 echo l:loclist[l:low]
" 
"     if l:low == l:high 
"         if IsAhead(l:loclist[l:low], l:curloc)
"             " This confirms the binary search has narrowed down
"             
" endfunction
"
