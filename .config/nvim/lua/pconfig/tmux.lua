return {
	"aserowy/tmux.nvim",
	keys = {
		"<C-l>",
		"<C-h>",
		"<C-j>",
		"<C-k>",
	},
	config = function()
		require("tmux").setup({
			-- overwrite default configuration
			-- here, e.g. to enable default bindings
			copy_sync = {
				-- enables copy sync and overwrites all register actions to
				-- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
				enable = false,
			},
			navigation = {
				-- cycles to opposite pane while navigating into the border
				cycle_navigation = true,
				-- enables default keybindings (C-hjkl) for normal mode
				enable_default_keybindings = true,
			},
			resize = {
				-- enables default keybindings (A-hjkl) for normal mode
				enable_default_keybindings = true,
			},
		})

		local tmux = require("tmux")

		vim.keymap.set("i", "<C-l>", tmux.move_right, { desc = "move right" })
		vim.keymap.set("i", "<C-h>", tmux.move_left, { desc = "move left" })
		vim.keymap.set("i", "<C-j>", tmux.move_down, { desc = "move down" })
		vim.keymap.set("i", "<C-k>", tmux.move_up, { desc = "move up" })
	end,
}
