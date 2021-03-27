echom "HELLOOOO. after/ftplugin/css.vim loaded."
" TODO: Wait until ALE gets support for a CSS LSP (most likely the VScode one
" and use ALE here)
let b:ale_completion_enabled=0
set omnifunc=syntaxcomplete#Complete

let b:ale_linters = [ 'csslint' ]
let b:ale_fixers = [ 'prettier' ]

set formatoptions-=t
set expandtab
set tabstop=2 " show existing tab with 2 spaces width
set softtabstop=2
set shiftwidth=2 " when indenting with '>', use 2 spaces width

