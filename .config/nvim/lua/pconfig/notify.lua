local wk = require("which-key")
wk.register({
	["<leader>n"] = {
		name = "notifications",
		d = { require("notify").dismiss, "dismiss notifictions" },
		f = { function () 	require("telescope").extensions.notify.notify()
end, "show past notifications" },
	},
})

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
