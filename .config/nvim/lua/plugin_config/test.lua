vim.g["test#strategy"] = "dispatch" -- Use tpope/vim-dispatch to run tests (the default (neovim terminal) one doesn't relay errors to quickfix. 
vim.g["test#ruby#rspec#executable"] = 'bundle exec rspec'


vim.cmd([[
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tg :TestVisit<CR>
]])
