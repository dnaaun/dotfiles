return {
	"levouh/tint.nvim",
	config = function()
		require("tint").setup({
			tint = -75,
			saturation = 0.2, -- Saturation to preserve
		})
	end,
}
