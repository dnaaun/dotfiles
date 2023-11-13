if vim.g.started_by_firenvim then
	-- disable statusline
	-- https://www.reddit.com/r/neovim/comments/10u9zga/help_how_to_hide_statusline/#:~:text=set%20ls%3D0%20this%20command%20hide%20statusline%20for%20vertical%20split.
	vim.cmd([[
  set laststatus=0
  hi! link StatusLine Normal
  hi! link StatusLineNC Normal
  set statusline=%{repeat('─',winwidth('.'))}
  ]])

	-- set guifont
	vim.cmd("set guifont=JetBrains\\ Mono\\ NL:h15")
end

return {
	"glacambre/firenvim",

	-- Lazy load firenvim
	-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
	lazy = not vim.g.started_by_firenvim,
	build = function()
		vim.fn["firenvim#install"](0)
	end,
}
