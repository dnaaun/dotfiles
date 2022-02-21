return {
	"nvim-lualine/lualine.nvim",
	requires = { "kyazdani42/nvim-web-devicons" },
	config = function()
		require("lualine").setup()
	end,
}
