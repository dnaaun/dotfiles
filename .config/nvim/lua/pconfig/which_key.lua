return {
	"folke/which-key.nvim",
	config = function()
		-- Set timeout to zero so that which-key thing shows up super quickly
		vim.opt.timeoutlen = 0

		-- How to disable some operators? (like v)
		local presets = require("which-key.plugins.presets")
		presets.operators["v"] = nil

		require("which-key").setup({
			layout = {
				height = { min = 4, max = 200 },
				width = { min = 20, max = 200 }, -- min and max width of the columns
			},
		})
	end,
}
