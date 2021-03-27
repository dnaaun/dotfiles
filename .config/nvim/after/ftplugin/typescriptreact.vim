set omnifunc=ale#completion#OmniFunc

let b:ale_linters = [ 'tsserver' ]
let b:ale_fixers = [ 'prettier' ]

set formatoptions-=t
set expandtab
set tabstop=2 " show existing tab with 2 spaces width
set softtabstop=2
set shiftwidth=2 " when indenting with '>', use 2 spaces width

