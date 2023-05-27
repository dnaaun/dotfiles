vim.api.nvim_exec(
	[[
augroup VimLeaveSaveSession
  autocmd VimLeave * SaveSession
augroup END
]],
	false
)


return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_save_enabled = true,
			auto_restore_enabled = false,
		})
	end,
}
