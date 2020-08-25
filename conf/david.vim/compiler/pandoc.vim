if exists("current_compiler")
    finish
endif

let current_compiler = "pandoc"
let &l:makeprg=current_compiler


