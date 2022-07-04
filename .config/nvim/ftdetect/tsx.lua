vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	pattern = "*.tsx",
	callback = function()
		-- THe reason I'm preferring tsx to typescriptreact is because treehopper.nvim,
		-- which is an AMAZING plugin, requires that the filetype matches the "name" of the
		-- treesitter parser.
		vim.opt_local.filetype = "tsx"

    -- I copied over the formatoptions from a `.ts file because I preferred how
    -- when you are typing comments, and you press enter, the new line has a comment prefix too.
		vim.opt_local.formatoptions = {
			c = true,
			j = true,
			l = true,
			o = true,
			q = true,
			r = true,
		}
	end,
})
