set textwidth=88 " Google Styleguide

augroup JediRelated
	" Jedi for go to definition
	au!
	nnoremap gd :call jedi#goto()<CR>
	nnoremap K :call jedi#show_documentation()<CR>
	nnoremap <Leader>s :call jedi#goto_stubs()<CR>
	nnoremap <Leader>r :call jedi#rename()<CR>
	nnoremap <Leader>d :call jedi#goto_definition()<CR>
	nnoremap <Leader>u :call jedi#usages()<CR>
	" Needed for jedi#show_call_signatures
	setlocal noshowmode
augroup end

" I have black to do formatting, don't wrap lines
set formatoptions-=t
set nowrap

compiler dmypy

" Setup a shortcut for tagbar
augroup TagBar
	au!
	nnoremap <Leader>t :TagbarToggle<CR>
augroup END

" Enable deoplete
call deoplete#enable()
