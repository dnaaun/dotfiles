vim.keymap.set("n", "<leader>nd", require("notify").dismiss, { desc = "dismiss notifictions" })
vim.keymap.set("n", "<leader>nf", function()
	require("telescope").extensions.notify.notify()
end, { desc = "show past notifications" })

return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	keys = {
		"<leader>nd",
		"<leader>nf",
	},
	config = function()
		-- Using this, we can do `require('telescope').extensions.notify.notify(<opts>)` to
		-- launch telescope and search through notification history.
		require("telescope").load_extension("notify")

		local notify = require("notify")
		notify.setup({
			render = "minimal",
			-- stages = {},
		})
	end,
}
