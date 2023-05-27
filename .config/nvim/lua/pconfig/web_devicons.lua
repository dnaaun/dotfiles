return {
	"nvim-tree/nvim-web-devicons",
  event = { "CursorHold" },
	config = function()
		require("nvim-web-devicons").setup({})
	end,
}
