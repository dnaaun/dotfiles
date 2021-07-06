"""""""""""""""""""""" not plugin-specific login """""""""""""""""""""""
" Use whatever python3 virtualenv is currently activated.
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
" open and close quickfix
nnoremap <Leader>qo :copen<CR>
nnoremap <Leader>qc :cclose<CR>
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
inoremap <C-s> <c-g>u<Esc>[s1z=`]a<c-g>u
" lspsaga doesn't have go to type definition.
" We use gT instead of gt cuz gt means, something (I forget what) in vim.
nnoremap gT :luado vim.lsp.buf.type_definition()<CR>


"""""""""""""""""""""""" Add plugins """""""""""""""""""""""""""""""
call plug#begin()
Plug 'mhartington/oceanic-next'
Plug 'christoomey/vim-tmux-navigator'

" Avoid loading most plugins if we're on a temporary  file (which is the case when 
" bash launches my $EDITOR to edit my commands), for speed. 
let s:temp_file_ptrn = '\v^/(tmp|scratch)/.*'
let s:NOT_IN_TEMP_FILE =  !(expand('%') =~ s:temp_file_ptrn)

if (s:NOT_IN_TEMP_FILE)
    Plug 'embear/vim-localvimrc' " Enable sourcing .lnvimrc files
    Plug 'sedm0784/vim-resize-mode' " After doing <C-w>,  be able to type consecutive +,-,<,>
    
    " General coding
    Plug 'neovim/nvim-lspconfig' " Neovim's builtin LSP client
    Plug 'glepnir/lspsaga.nvim' " A "light-weight lsp plugin"
    Plug 'hrsh7th/nvim-compe' " Auto completion for neovim
    Plug 'urbainvaes/vim-ripple', {'for': ['javascript', 'typescript', 'python'] } " Send code to REPLs easily
    Plug 'mfussenegger/nvim-dap' " TODO: Set this up to replace vim-ripple.
    Plug 'simrat39/symbols-outline.nvim' " Either nvim's LSP, or pyright, isn't yielding workspace/symbols, gotta fix that ...
    Plug 'nvim-treesitter/nvim-treesitter' " Do highlighting, indenting, based on ASTs
    Plug 'nvim-treesitter/nvim-treesitter-textobjects' " Text objects based on syntax trees!!
    Plug 'famiu/nvim-reload' " Adds :Reload and :Restart to make reloading lua easier
    Plug 'ray-x/lsp_signature.nvim' " Show func signatures automatically
    Plug 'folke/trouble.nvim' " Basically a slightly nicer loclist that works well with Neovim's LSP and Telescope
    Plug 'mhartington/formatter.nvim' " Replace ALE's formatting

    " Python
    Plug 'vim-test/vim-test', { 'for': ['python'] }
    Plug 'tpope/vim-dispatch', { 'for': ['python'] } " Here only cuz vim-test

    " (Fuzzy) search everything!
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }


    Plug 'tpope/vim-unimpaired' "" TPope makes vim sane
    Plug 'tpope/vim-vinegar' " Better netrw
    Plug 'tpope/vim-fugitive' "" Git
    Plug 'tpope/vim-obsession' "" Session management

    "" CSS
    Plug 'ap/vim-css-color', { 'for': ['css'] } " Highlight css colors

    "" Writing
    " Markdown
    Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
    Plug 'iamcco/markdown-preview.nvim', {
                \ 'for': ['markdown'],
                \ 'do': { -> mkdp#util#install() },
                \ }

    " Tex
    Plug 'lervag/vimtex', { 'for': 'tex' }
    Plug 'KeitaNakamura/tex-conceal.vim', { 'for': 'tex' }
    Plug 'SirVer/ultisnips', { 'for': ['tex', 'markdown', 'snippets', 'python'], 'commit': '96026a4df27899b9e4029dd3b2977ad2ed819caf' } 
    
    "" Colors and other niceties
    Plug 'hoob3rt/lualine.nvim'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'kyazdani42/nvim-web-devicons'
else
    echomsg 'Tmp file: not loading some plugins'
endif
call plug#end()


""""""""""""""""""""""" Colorscheme """"""""""""""""""""""""""""""""""
colorscheme OceanicNext


""""""""""""""""""""""" vim-ripple """""""""""""""""""""""""""""""""""
" The python one is strongly informed by https://github.com/urbainvaes/vim-ripple/issues/20
let g:ripple_repls = {
            \ 'python': ['ptpython --vi', "", "\<cr>", 0],
            \ 'javascript': ['deno', "", "\<cr>", 0],
            \ 'typescript': ['deno', "", "\<cr>", 0] 
            \ }
let g:ripple_enable_mappings=0 " Disable default mappings (which are mostly Ctrl based and suck)

" Vim-ripple
" Open repl
nmap <leader>ro <Plug>(ripple_open_repl)
" Send  text contained in next motion to repl
nmap <leader>r <Plug>(ripple_send_motion)
" In select mode, send selection
xmap <leader>r <Plug>(ripple_send_selection)
" Send line. Two r's to make it simple.
nmap <leader>rr <Plug>(ripple_send_line)



"""""""""""""""""""""""""""" vimtex """""""""""""""""""""""""""""""""
"" Vimtex settings
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
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
      \ if !&modified && s:NOT_IN_TEMP_FILE |
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
let g:airline_theme='oceanicnext'
" No error messages about whitespaces please
let g:airline#extensions#whitespace#enabled = 0


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


""""""""""""""""""" vim-test """""""""""""""""""""""""""
let test#strategy = "dispatch"
let g:dispatch_tmux_height = 10 " Foundt this by reading dispatch.vim source code

nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

"""""""""""""""""""" fugitive.vim """""""""""""""""""""""
nnoremap <Leader>gs :Git!<CR>
nnoremap <Leader>gd :Gdiffsplit<CR>
nnoremap <Leader>gc :Git commit<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gpull --rebase<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gg :Git 

"""""""""""""""""""" limelight.vim """"""""""""""""""""""""""""
let g:limelight_paragraph_span=5
let g:limelight_bop = '^'
let g:limelight_eop = '$'
" When using fzf terminal splits, toggle Limelight.
" This exists() trick below was taken by reading limelight src at
" autoload/limelight.vim
let s:ll_was_on=0
"
"""""""""""""""""""" goyo.vim """"""""""""""""""""""""""""
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
            " + 3 for good measure (aka error indicators)
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


"""""""""""""""""""" vim-tmux-navigator """""""""""""""""""""""""
inoremap <C-j> <C-\><C-o>:TmuxNavigateDown<CR>
inoremap <C-k> <C-\><C-o>:TmuxNavigateUp<CR>
inoremap <C-h> <C-\><C-o>:TmuxNavigateLeft<CR>
inoremap <C-l> <C-\><C-o>:TmuxNavigateRight<CR>
" Repeat same mappings for terminal mode in neovim
tnoremap <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
tnoremap <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
tnoremap <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
tnoremap <C-l> <C-\><C-n>:TmuxNavigateRight<CR>


"""""""""""""""""""""" netrw """""""""""""""""""""""
let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
let g:netrw_localrmdir='rm -r' " Allow netrw to remove non-empty local directories
let g:netrw_keepdir=1 " Make netrw moving work 
let g:netrw_sort_by='time' " Netrw sort by time in descending order
let g:netrw_sort_direction='reverse'

""""""""""""""""""""""""" Ultisnips """""""""""""""""""""""""""""""""'
" The only reason this section is here is because I need to define the
" following function to get ultisnips and nvim-compe working the way I want
" them to.
function! UltiSnips_IsExpandable()
return !(
  \ col('.') <= 1
  \ || !empty(matchstr(getline('.'), '\%' . (col('.') - 1) . 'c\s'))
  \ || empty(UltiSnips#SnippetsInCurrentScope())
  \ )
endfunction


""""""""""""""" Plugin configuration separated out to files """"""""
lua <<EOF
require 'plugin_config.nvim_compe'
require 'plugin_config.telescope'
require 'plugin_config.lsp_config'
require 'plugin_config.lspsaga'
require 'plugin_config.symbols_outline'
require 'plugin_config.nvim_treesitter'
require 'plugin_config.nvim_treesitter_textobjects'
require 'plugin_config.lsp_signature'
require 'plugin_config.trouble'
require 'plugin_config.lualine'
require 'plugin_config.formatter'
EOF
luado vim.lsp.set_log_level("debug")


"""""""""""""""""""""""""" Secondary init file """""""""""""""""""""""""""""
" Include a "secondary" init file that is machine-specific (ie, not racked in this repo)
let s:secondary_init_vim=expand('~/.secondary.init.vim')
if filereadable(s:secondary_init_vim)
    execute 'source' s:secondary_init_vim
endif
