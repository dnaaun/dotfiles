set formatoptions-=t
set nowrap


" Set omnifunc
set omnifunc=ale#completion#OmniFunc


set expandtab
" show existing tab with 2 spaces width
set tabstop=4
set softtabstop=4
" when indenting with '>', use 2 spaces width
set shiftwidth=4

"" Ale
let b:ale_linters = [ 'rls' ] 
" let b:ale_fixers = { 'python': ['black']}

let g:ale_rust_rls_toolchain = 'stable' " this is needed, otherwise rls uses nightly toolchain

