vim.api.nvim_create_autocmd("FileType", {
	pattern = "org",
	group = vim.api.nvim_create_augroup("orgmode_telescope_nvim", { clear = true }),
	callback = function()
		vim.keymap.set("n", "<leader>xr", require("telescope").extensions.orgmode.refile_heading)
	end,
})

return { "joaomsa/telescope-orgmode.nvim" }
