return {
	"akinsho/bufferline.nvim",
  event = { "CursorHold" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		if vim.g.started_by_firenvim then
			return
		end
		require("bufferline").setup({})
	end,
}
