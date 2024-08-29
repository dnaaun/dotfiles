return {
	"luckasRanarison/nvim-devdocs",
	cmd = {
		"DevdocsOpen",
		"DevdocsFetch",
		"DevdocsInstall",
		"DevdocsUninstall",
		"DevdocsOpenFloat",
		"DevdocsUpdate",
		"DevdocsUpdateAll",
		"DevdocsOpenCurrent",
	},
	keys = {
		"<leader>df",
		"<leader>dd",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-devdocs").setup({
			filetypes = {
				sql = { "postgres" },
			},
		})

		vim.keymap.set("n", "<leader>df", "<cmd>DevdocsOpenCurrent<CR>", { desc = "open dev docs for current file" })
		vim.keymap.set("n", "<leader>dd", "<cmd>DevdocsOpen<CR>", { desc = "open dev docs" })
	end,
}
