" https://github.com/lambdalisue/mypy-compiler.vim
let &l:makeprg = 'dmypy run --  "%"'
setlocal cmdheight=2 "dmypy flags take up a lot of space"
setlocal errorformat=
            \%E%f:%l:\ error:\ %m,
            \%I%f:%l:\ note:\ %m
