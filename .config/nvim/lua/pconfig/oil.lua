-- Needed this because something keeps "unmapping" `-` after a bit of time.
local augroup = vim.api.nvim_create_augroup("MyAutocommands", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	group = augroup,
	callback = function()
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
})

return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			skip_confirm_for_simple_edits = true,
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = true,
			},
			-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
			-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
			-- Additionally, if it is a string that matches "actions.<name>",
			-- it will use the mapping at require("oil.actions").<name>
			-- Set to `false` to remove a keymap
			-- See :help oil-actions for a list of all available actions
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = false,
				["<C-h>"] = false,
				["<C-t>"] = false,
				["<C-p>"] = "actions.preview",
				["<C-c>"] = false,
				["<C-l>"] = false,
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = {
					"actions.cd",
					opts = { scope = "tab" },
					desc = ":tcd to the current oil directory",
					mode = "n",
				},
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["g\\"] = "actions.toggle_trash",
			},
			-- Set to false to disable all of the above keymaps
			use_default_keymaps = true,
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
