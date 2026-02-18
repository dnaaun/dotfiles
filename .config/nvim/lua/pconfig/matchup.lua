return {
	"andymass/vim-matchup",
	init = function()
		vim.g.matchup_matchparen_deferred = 1
		vim.g.matchup_matchparen_deferred_show_delay = 100
		vim.g.matchup_matchparen_offscreen = {}
		-- Disable treesitter integration (major perf bottleneck via luaeval bridge)
		vim.g.matchup_treesitter_enabled = 0
	end,
}
