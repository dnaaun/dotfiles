" Use the cppman program for help
" Use cppman for Shift-K
setlocal keywordprg=:term\ cppman

" Use ALE for all the LSP-like things
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gu :ALEFindReferences<CR>
nnoremap gr :ALERename<CR>

nnoremap Gd :ALEGoToDefinition -vsplit<CR>
nnoremap Gu :ALEFindReferences -vsplit<CR>


" https://stackoverflow.com/a/1878984
set tabstop=2       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=2    " Indents will have a width of 4

set softtabstop=2   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces

" Use ALE for autocomplete
set omnifunc=ale#completion#OmniFunc
