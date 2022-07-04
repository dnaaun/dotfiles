return {
	"rcarriga/nvim-notify",
	config = function()
		-- Using this, we can do `require('telescope').extensions.notify.notify(<opts>)` to
		-- launch telescope and search through notification history.
		require("telescope").load_extension("notify")

		local notify = require("notify")

		-- Replace the usual notify with this plugin so that `print()` uses this plugin
		vim.notify = notify

		vim.keymap.set("n", "<leader>fn", require("telescope").extensions.notify.notify)
		vim.keymap.set("n", "<Leader>nd", notify.dismiss, {})
	end,
}
