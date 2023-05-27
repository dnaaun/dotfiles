vim.g.matchup_matchparen_enabled = false
vim.g.matchup_matchparen_enabled = false
vim.g.matchup_motion_enabled = true
vim.g.matchup_text_obj_enabled = false


return {
	"andymass/vim-matchup",
  event = "VeryLazy",
	ft = { "ruby", "typescriptreact", "typescript", "javascript", "javascriptreact", "lua" },
}
