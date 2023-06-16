lua _G.PAGER_MODE=true
source ~/.config/nvim/init.lua

" nomodifiable breaks which-key.
" set nomodifiable
set nowrap

" Don't prompt to save before exiting
" https://stackoverflow.com/a/57930716
autocmd ExitPre * q!
nmap <silent> <buffer> q :quit<CR>

" Activate norcalli/nvim-terminal.lua
set filetype=terminal
