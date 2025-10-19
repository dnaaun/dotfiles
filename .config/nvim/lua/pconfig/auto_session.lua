vim.api.nvim_exec(
	[[
augroup VimLeaveSaveSession
  autocmd VimLeave * AutoSession save
augroup END
]],
	false
)

vim.api.nvim_create_augroup("RestoreSessionOnEnter", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	group = "RestoreSessionOnEnter",
	callback = function()
		local arglist = vim.api.nvim_get_vvar("argv")
		local filtered_arglist = {}
		for _, arg in ipairs(arglist) do
			if arg ~= "--embed" then
				table.insert(filtered_arglist, arg)
			end
		end
		if #filtered_arglist == 1 then
			vim.cmd("AutoSession restore")

			-- I've setup nvim-lspconfig to load onlyi on BufRead, and that event
			-- doesn't seem to be triggered when restoring a session.
			vim.cmd("doautocmd BufRead")
		end
	end,
	nested = true,
})

return {
	"rmagatti/auto-session",
	module = "auto-session",
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_save_enabled = false,
			auto_restore_enabled = false,
			pre_save_cmds = {
				'lua require("dapui").close()',
			},
		})
	end,
}
