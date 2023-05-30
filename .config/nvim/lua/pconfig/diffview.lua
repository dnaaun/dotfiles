return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	keys = { "<leader>gd", "<leader>gq" },
  cmd = { "DiffviewFileHistory", "DiffviewOpen" },
	config = function()
		local wk = require("which-key")
		wk.register({
			g = {
				name = "git",
				d = { ":DiffviewOpen<CR>", "Diffview Open" },
				q = { ":tabclose<CR>", "Tab Close" },
			},
		}, { prefix = "<leader>" })

		local cb = require("diffview.config").diffview_callback

		require("diffview").setup({
			key_bindings = {
				file_panel = {
					["<cr>"] = cb("focus_entry"),
				},
			},
		})
	end,
}
