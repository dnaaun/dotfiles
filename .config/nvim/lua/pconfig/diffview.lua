vim.api.nvim_set_keymap("n", "<leader>gg", ":DiffviewOpen<CR>", {})

return {
	"sindrets/diffview.nvim",
	requires = "nvim-lua/plenary.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}
