" Text iwidth
set tw=88

set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2


" Enable spelling
set spell

"  Make bold, italics, and so forth
let g:vim_markdown_conceal=1
set conceallevel=2

" Spelling corrections are quicker when completion inserts the first match (or subsequent matches)
" without having to press a combo.
set completeopt-=noinsert

" Vim sources it's own ftpluign/html.vim which sets "r"
setlocal formatoptions-=r " Don't conitnue quotes on next line when pressing return
