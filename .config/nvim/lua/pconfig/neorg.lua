return {
	"nvim-neorg/neorg",
	config = function()
		require("neorg").setup({
			load = {
        ["core.export"] = {},
				["core.norg.concealer"] = {},
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
