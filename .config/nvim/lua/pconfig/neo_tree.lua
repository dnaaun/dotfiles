return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	config = function()
		-- vim.keymap.set("n", "<leader>c", "<cmd>Neotree filesystem reveal left<CR>", {})
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
}
