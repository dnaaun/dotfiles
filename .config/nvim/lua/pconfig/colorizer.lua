return {
	"crivotz/nvim-colorizer.lua",
	ft = { "tsx", "css", "javascriptreact" },

	-- If you're reading this in a CSS file, #0ED should be highlighted with light blue. Thank you nvim-colorizer.
	config = function()
		require("colorizer").setup()
	end,
}
