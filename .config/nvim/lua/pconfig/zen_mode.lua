require("std2").mapfunc("n", "<leader>v", function()
	require("zen-mode").toggle()
end, {}, "toggle zen-mode")

return {
	"folke/zen-mode.nvim",
	branch = "main",
	module = { "zen-mode" },
	config = function()
		require("zen-mode").setup({})
	end,
}
