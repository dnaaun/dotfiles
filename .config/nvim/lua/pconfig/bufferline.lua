return {
	"akinsho/bufferline.nvim",
	requires = "kyazdani42/nvim-web-devicons",
	config = function()
		if vim.g.started_by_firenvim then
			return
		end
		require("bufferline").setup({})
	end,
}
