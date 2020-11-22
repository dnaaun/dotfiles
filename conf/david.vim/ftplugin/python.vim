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
augroup end

" Black to do formatting, don't wrap lines
set formatoptions-=t
set nowrap


" Set omnifunc
set omnifunc=ale#completion#OmniFunc

set noshowmode " jedi docs say we need this for the below.
let g:jedi#show_call_signatures=1
" auto_initialization is 0, so we gotta do this for call signatures.
call jedi#configure_call_signatures()

set expandtab
" show existing tab with 2 spaces width
set tabstop=4
set softtabstop=4
" when indenting with '>', use 2 spaces width
set shiftwidth=4


" Use the pytest compiler (look in ../compiler/pytest.vim) if we are in an
" a file that looks like a test file.
if expand('%:t') =~ 'test_.*\.py'
    compiler pytest
endif

