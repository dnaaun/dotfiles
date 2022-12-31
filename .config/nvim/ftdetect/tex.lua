vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.jsx",
	callback = function()
		vim.opt_local.filetype = "tex"
	end,
})
