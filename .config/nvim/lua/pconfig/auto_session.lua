vim.api.nvim_exec(
	[[
augroup VimLeaveSaveSession
  autocmd VimLeave * SaveSession
augroup END
]],
	false
)

local g = vim.api.nvim_create_augroup("SessionLoad", {})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = g,
	nested = true,
	callback = function()
		if not vim.g.started_by_firenvim and #vim.v.argv == 1 then
			require("auto-session").RestoreSession()
    end
    if vim.g.started_by_firenvim then
      vim.o.guifont="Fira_Code:h24"
      vim.opt_local.filetype = "markdown"
		end
		return true
	end,
})

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
