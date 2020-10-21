let g:tex_flavor='latex'

" Modified from: https://github.com/gillescastel/latex-snippets
 
" Vimtex
let g:vimtex_view_method='zathura'
" This should be set automatically, actually.
set omnifunc=vimtex#complete#omnifunc


" tex-conceal.vim
set conceallevel=1
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none

" https://vi.stackexchange.com/questions/13080/setting-tab-to-2-spaces
" On pressing tab, insert 4 spaces
setlocal expandtab
" show existing tab with 4 spaces width
setlocal tabstop=4
setlocal softtabstop=4
" when indenting with '>', use 4 spaces width
setlocal shiftwidth=4
