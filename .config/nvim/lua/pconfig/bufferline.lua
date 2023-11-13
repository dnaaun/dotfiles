return {
	"akinsho/bufferline.nvim",
	event = { "CursorHold" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	enabled = not vim.g.started_by_firenvim,
	config = function()
		require("bufferline").setup({})
	end,
}
