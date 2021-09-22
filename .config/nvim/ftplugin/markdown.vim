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


" Vim sources it's own ftpluign/html.vim which sets "r"
setlocal formatoptions-=r " Don't conitnue quotes on next line when pressing return

" 'code block' text objects
" https://vim.fandom.com/wiki/Creating_new_text_objects
vnoremap a` :<C-u>?```<CR>v/```<CR>ll
vnoremap i` :<C-u>?```<CR>jv/```<CR>k
omap a` :normal Va`<CR>
omap i` :normal Vi`<CR>
