set textwidth=88 " Google Styleguide


" Black to do formatting, don't wrap lines
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


" Use the pytest compiler (look in ../compiler/pytest.vim) if we are in an
" a file that looks like a test file.
if expand('%:t') =~ 'test_.*\.py'
    compiler pytest
endif

" Run pyright everywhere!
if ! exists('g:ale_linters') 
    let g:ale_linters = {}
endif 
if ! exists('g:ale_linters["python"]')
    let g:ale_linters['python'] = []
endif
let g:ale_linters['python'] = g:ale_linters['python'] + ['pyright']
let g:ale_linters['python'] = g:ale_linters['python'] + ['mypy']
