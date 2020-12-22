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

" function! s:add_conf(conf, to_add)
" 	if type(a:conf) != type(a:to_add)
"         throw 'Type mismatch in add_conf call'
"     endif
" 
"     if type(a:conf) == v:t_list:
"         for item in a:to_add:
"             add(a:conf, item)
"         endfor
"     elseif type(a:conf) == v:t_dict:
"         for key in keys(a:to_add):
"             if exists('a:conf[key]')
"                 s:add_conf(a:conf[key], to_add[key]


if ! exists('b:ale_linters') 
    let b:ale_linters = {}
endif 
if ! exists('b:ale_linters["python"]')
    let b:ale_linters['python'] = []
endif
let b:ale_linters['python'] = b:ale_linters['python'] + ['pyright']
let b:ale_linters['python'] = b:ale_linters['python'] + ['mypy']
let b:ale_fixers = { 'python': ['black']}

let b:ale_python_mypy_options="--show-error-codes --allow-redefinition"
