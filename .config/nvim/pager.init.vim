source ~/.config/nvim/init.vim

set nomodifiable
set nowrap

" Don't prompt to save before exiting
" https://stackoverflow.com/a/57930716
autocmd ExitPre * q!
nmap <silent> <buffer> q :quit<CR>
