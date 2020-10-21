
" This shouldn't be needed actually.
augroup reload_snippets
    autocmd!
    autocmd BufWrite <buffer> :call UltiSnips#RefreshSnippets()
augroup END
