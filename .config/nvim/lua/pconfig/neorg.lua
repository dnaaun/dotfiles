return {
	"nvim-neorg/neorg",
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.integrations.nvim-cmp"] = {
					config = {
						-- Configuration here
					},
				},
			},
		})
	end,
	requires = "nvim-lua/plenary.nvim",
}
