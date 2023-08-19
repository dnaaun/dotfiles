return {
	"kwkarlwang/bufjump.nvim",
	config = function()
		require("bufjump").setup({
			forward = "<leader>i",
			backward = "<leader>o",
			on_success = nil,
		})
	end,
}
