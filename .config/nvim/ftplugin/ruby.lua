-- Doing this NOT on every BufEnter is not working
vim.api.nvim_create_autocmd({ "BufAdd", "BufCreate", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("RubyRemoveSomeIndentKeys", {}),
	pattern = "*.rb",
	callback = function(args)
		-- It's really annoying when the line is de-dented when typing a period.
		vim.opt_local.indentkeys:remove(".")
		vim.opt_local.indentkeys:remove("{")
		vim.opt_local.indentkeys:remove("}")
	end,
})
