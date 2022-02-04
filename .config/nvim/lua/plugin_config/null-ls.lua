local null_ls = require("null-ls")

local stylua = null_ls.builtins.formatting.stylua.with({
	extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
})

local black = null_ls.builtins.formatting.black

sqlformat = null_ls.builtins.formatting.sqlformat
stylua = null_ls.builtins.formatting.stylua

null_ls.config({ sources = { stylua, black, sqlformat, null_ls.builtins.formatting.prettier, stylua } })
