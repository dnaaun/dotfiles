-- local g = vim.api.nvim_create_augroup("DisableFoldingOrg", {})
-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = g,
-- 	pattern = "org",
-- 	callback = function()
-- 		vim.opt_local.foldenable = false
-- 	end,
-- })

return {
	"nvim-orgmode/orgmode",
	ft = { "org" },
	config = function()
		require("orgmode").setup_ts_grammar()
		require("orgmode").setup({
			org_agenda_files = { "~/Dropbox/notes/org/agenda/**" },
			org_default_notes_file = "~/Dropbox/notes/org/agenda/refile.org",
		})
	end,
}
