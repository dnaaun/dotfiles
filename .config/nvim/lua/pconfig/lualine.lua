return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "CursorHold",
	config = function()
		require("lualine").setup()
	end,
}
