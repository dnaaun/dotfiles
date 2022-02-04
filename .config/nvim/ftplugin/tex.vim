" tex-conceal.vim
set conceallevel=2
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none

" Needs to be strictly less than the "columns" option
" provided to latexindent.pl because latexindent.pl acts as if
" "overflow" is set sometimes.
setlocal textwidth=79

" https://vi.stackexchange.com/questions/13080/setting-tab-to-2-spaces
" On pressing tab, insert 2 spaces
setlocal expandtab
" show existing tab with 2 spaces width
setlocal tabstop=2
setlocal softtabstop=2
" when indenting with '>', use 2 spaces width
setlocal shiftwidth=2

" Suggestion of vimtex docs 
" To enable adding latex environments using vim-surround
let b:surround_{char2nr('e')} = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
let b:surround_{char2nr('c')} = "\\\1command: \1{\r}"


set nohlsearch
set formatoptions-=c " Don't insert bullet on auto-wrap
set spell



let b:ale_tex_latexindent_options  = '-m'

" Vimtex doesn't load if this isn't set.
let g:tex_flavour='latex'

setlocal autoindent

" Have less annoying auto indentation: https://old.reddit.com/r/neovim/comments/991kmv/annoying_auto_indentation_in_tex_files/e4ldbfk/
setlocal autoindent
let g:tex_indent_items=0
let g:tex_indent_and=0
let g:tex_indent_brace=0
