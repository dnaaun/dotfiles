" Set omnifunc to ALE, completefunc to jedi, because only ALE does autoimport
set omnifunc=ale#completion#OmniFunc 
" set omnifunc=
set completefunc=jedi#completions

set textwidth=88 " Google Styleguide
set formatoptions-=t
set nowrap " Black to do formatting, don't wrap lines
set expandtab
set tabstop=4 " show existing tab with 2 spaces width
set softtabstop=4
set shiftwidth=4 " when indenting with '>', use 2 spaces width

" Use the pytest compiler (look in ../compiler/pytest.vim) if we are in an
" a file that looks like a test file.
if expand('%:t') =~ 'test_.*\.py'
    compiler pytest
endif

"" Ale
let b:ale_fixers = { 'python': ['black']}
let b:ale_linters = [ 'mypy', 'pyright' ]
" let b:ale_python_mypy_options="--no-pretty --show-error-codes --allow-redefinition" " Mypy bugs out with allennlp

"" Mappings
" nvim-ipy, go to next cell.
" j or k is to go one line below/above the cell boundary line.
" :noh is to clear highlights in case hlsearch is set.
" zz is to center the cursor vertically.
nmap ]c :execute '/' . g:ipy_celldef<CR>j:noh<CR>zz
nmap [c :execute '?' . g:ipy_celldef<CR>k:noh<CR>zz

" Jedi for docs
nmap K :call jedi#show_documentation()<CR>

" This is needed to show call sigs in prev win. Doesn't work in init.vim, must be in
" ftplugin.
" call jedi#configure_call_signatures() " Disabled cuz it's currently causing problems

" WHen typing an open bracket, check if ale docs are available
imap <buffer> ( (<C-\><C-o>:ALEHover<CR>
