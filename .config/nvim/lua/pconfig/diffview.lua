vim.api.nvim_set_keymap("n", "<tab><tab>", ":DiffviewOpen<CR>", {})
vim.api.nvim_set_keymap("n", "<leader>gg", ":DiffviewOpen<CR>", {})

-- The only reason I use (and therefore, close) tabs is for diffview,
-- so mapping for :tabclose is here.
vim.api.nvim_set_keymap("n", "<leader>gq", ":tabclose<CR>", {})

return {
	"sindrets/diffview.nvim",
	requires = "nvim-lua/plenary.nvim",
	-- Keybindings  act funny when we do this.
	-- cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	config = function()
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
