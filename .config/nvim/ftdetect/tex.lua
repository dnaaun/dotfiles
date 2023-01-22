vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.tex",
	callback = function()
		vim.opt_local.filetype = "tex"
	end,
})
