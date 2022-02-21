return {
	"folke/which-key.nvim",
	config = function()
		require("which-key").setup({
			layout = {
				height = { min = 4, max = 200 },
				width = { min = 20, max = 200 }, -- min and max width of the columns
			},
		})
	end,
}
