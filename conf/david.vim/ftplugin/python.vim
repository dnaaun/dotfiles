set textwidth=88 " Google Styleguide

augroup JediRelated
	" Jedi for go to definition
	au!
	nnoremap gd :call jedi#goto()<CR>
	nnoremap K :call jedi#show_documentation()<CR>
	nnoremap <Leader>js :call jedi#goto_stubs()<CR>
	nnoremap <Leader>jr :call jedi#rename()<CR>
	nnoremap <Leader>jd :call jedi#goto_definitions()<CR>
	nnoremap <Leader>ja :call jedi#goto_assignments()<CR>
	nnoremap <Leader>ju :call jedi#usages()<CR>
	" Needed for jedi#show_call_signatures
	setlocal noshowmode
augroup end

" Black to do formatting, don't wrap lines
set formatoptions-=t
set nowrap

" Show docstring in preview window
let g:deoplete#sources#jedi#show_docstring = 1
" Enable deoplete
call deoplete#enable()
 

" Setup a shortcut for tagbar
augroup TagBar
	au!
	nnoremap <Leader>t :TagbarToggle<CR>
augroup END
