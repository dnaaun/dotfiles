return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "CursorHold",
	enabled = not vim.g.started_by_firenvim,
	config = function()
		require("lualine").setup()
	end,
}
