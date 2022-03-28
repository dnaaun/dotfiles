return {
	"pwntester/octo.nvim",
	requires = { "kyazdani42/nvim-web-devicons" },
	config = function()
		require("octo").setup()
	end,
}
